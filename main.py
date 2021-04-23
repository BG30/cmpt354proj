from functools import wraps

import char as char
from flask import Flask, render_template, request, flash, redirect, url_for, session, logging
from data import Items
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from wtforms import Form, StringField, TextField, PasswordField, validators
from passlib.hash import sha256_crypt
import psycopg2
from psycopg2.extras import DictCursor
from validate_email import validate_email

app = Flask(__name__)

Items = Items()
# db = 'postgresql://postgres:root@localhost/eprice'
con = psycopg2.connect(database="postgres", user="postgres", password="pass", host="127.0.0.1", port="5432")

def select_rows_dict_cursor(self, query):
    """Run SELECT query and return list of dicts."""
    self.connect()
    with self.conn.cursor(cursor_factory=DictCursor) as cur:
        cur.execute(query)
        records = cur.fetchall()
    cur.close()
    return records


curs = con.cursor()


@app.route('/')
def index():
    return render_template('home.html')


@app.route('/about')
def about():
    return render_template('about.html')

#page will show all items that match the user's input
@app.route('/items', methods=['GET', 'POST'])
def items():
    term = ''
    data = ''
    results = ''
    userid = ''
    if session:
        userid = session['user_id']
    
    if request.method == 'POST':
        if request.form.get("submit_search"):
            term = request.form['searchbar']
            results = number_of_results(term)
            data = search_results(term)
        elif request.form.get("submit_wishlist"):
            session['upc'] = request.form['submit_wishlist']
            session['listype'] = 'wishlist'
            session['wishlists'] = retrieve_allwishlists(str(session['user_id']))
            if session['wishlists'] == '':
                flash("No wishlist, make a wishlist first", 'danger')
                return redirect(url_for('addNewList'))
            return redirect(url_for('item'))
        elif request.form.get("submit_shoppinglist"):
            session['upc'] = request.form['submit_shoppinglist']
            session['listype'] = 'shoppinglist'
            return redirect(url_for('item'))
    return render_template('items.html', items = data, searchTerm = term, result = results, userid = userid)

#returns a json of all items which match a users product query
def search_results(term):
    query = """ 
                SELECT json_agg(u)
                FROM (
                    SELECT variety."Brand", variety."UPC", variety."Size", variety."StorageType",
                    (
                        SELECT json_agg(d)
                        FROM (
                            SELECT retailcompany."Name", retailcompany."Address", ppp."Price", ppp."Availability"
                            FROM retailcompany
                            FULL OUTER JOIN particularproductpricing AS ppp
                            ON variety."UPC" = ppp."UPC"
                            WHERE variety."ProductID" = (
                                SELECT product."ProductID"s
                                FROM product
                                WHERE product."Description" = '""" + term.lower() + """'     
                            ) AND ppp."RetailID" = retailcompany."RetailID"
                        ) d
                    ) AS pricingdetails
                        FROM variety
                ) u
                WHERE pricingdetails IS NOT NULL;
    """
    cur = con.cursor(cursor_factory = psycopg2.extras.RealDictCursor)
    cur.execute(query)
    rows= cur.fetchone()
    return rows

#returns the number of results that a user query will find
def number_of_results(term):
    query = """
                SELECT COUNT(*)
			    FROM retailcompany, variety
			    FULL OUTER JOIN particularproductpricing AS ppp
			    ON variety."UPC" = ppp."UPC"
			    WHERE variety."ProductID" = (
				    SELECT product."ProductID"
				    FROM product
				    WHERE product."Description" = '""" + term.lower() + """'     
			    ) AND ppp."RetailID" = retailcompany."RetailID"
            """

    cur = con.cursor(cursor_factory = psycopg2.extras.RealDictCursor)
    cur.execute(query)
    row = cur.fetchone()
    return row['count']

#page will indicate whether a item already or added in shopping list or options to add to wishlist
@app.route('/item', methods=['GET', 'POST'])
def item():
    message=''
    wishmessage=''
    if request.method == 'POST':
        upc = session['upc']
        wishmessage = add_to_wishlist(upc, request.form.get('pricebar'), request.form.get('wishlist_selection'), session['user_id'])
        session['listype']=''
        render_template('item.html', upc=upc, listype='', message='', wishlists='', wishmessage=wishmessage)
    elif session['listype'] == 'shoppinglist':
        message = add_to_shoppinglist(str(session['upc']), str(session['user_id']) )
        wishmessage=''
        wishlists=''
   
    return render_template('item.html', upc=session['upc'], listype=session['listype'], message=message, wishlists=session['wishlists'], wishmessage=wishmessage)

#inserts item into a shopping list
def add_to_shoppinglist(upc, userid):
    #check if the upc is already in the user's shopping list
    query = """ 
                SELECT COUNT(*)
                FROM listitems
                WHERE listitems."ListID" =
                (
                    SELECT shoppinglist."ListID"
                    FROM shoppinglist
                    WHERE shoppingList."ListID" IN
                    (
                        SELECT list."ListID"
                        FROM list
                        WHERE list."UserID" = """ + userid + """
                    )
                ) AND listitems."UPC" = """ + upc
        
    cur = con.cursor(cursor_factory = psycopg2.extras.RealDictCursor)
    cur.execute(query)
    row = cur.fetchone()

    #check if item in shopping list
    if row['count'] == 0:
        query = """
                    INSERT INTO listitems VALUES (
                        (
                            SELECT shoppinglist."ListID"
                            FROM shoppinglist
                            WHERE shoppingList."ListID" IN
                            (
                                SELECT list."ListID"
                                FROM list
                                WHERE list."UserID" = '""" + userid + """'
                            )
                        ), """ + upc + """
                    );
                """
        cur = con.cursor()
        cur.execute(query)
        con.commit()
    
        return ' has been successfully added '
    return ' already '

#returns wishlist with id and name of list
def retrieve_allwishlists(userid):
    cur = con.cursor(cursor_factory=psycopg2.extras.DictCursor)
    
    query = """
                SELECT COUNT(*)
                FROM list
                WHERE list."ListID" NOT IN (
                    SELECT shoppinglist."ListID"
                    FROM shoppinglist
                    LEFT JOIN list
                    ON shoppinglist."ListID" = list."ListID"
                ) AND list."UserID" = """ + userid
    
    cur.execute(query)
    testVal = cur.fetchone()

    if testVal['count'] == 0:
        return ''
    
    else:
        query = """ 
                
                    SELECT list."ListID", list."Name"
                    FROM list
                    WHERE list."ListID" NOT IN (
                       SELECT shoppinglist."ListID"
                        FROM shoppinglist
                        LEFT JOIN list
                        ON shoppinglist."ListID" = list."ListID"
                    ) AND list."UserID" = """ + userid + """
                
            """
        cur.execute(query)
        rows = cur.fetchall()
        return rows

#adds an item to a user's specified wishlist
def add_to_wishlist(upc, targetprice, wishlistid, userid):
    wishmessage = ''
    #check if unique item in wishlist for user
    query = """   
                SELECT COUNT(*)
                FROM listitems
                WHERE """ + upc + """ IN(
                    SELECT listitems."UPC"
                    FROM listitems
                    WHERE listitems."ListID" = """ + wishlistid + """
                );
            """

    cur = con.cursor(cursor_factory = psycopg2.extras.RealDictCursor)
    cur.execute(query)
    row = cur.fetchone()
    
    #unique item detected, add to wishlist and listitems
    if row['count'] == 0:
        insert_query1 = """
                            INSERT INTO listitems("ListID", "UPC") 
                            VALUES (""" + wishlistid + """ , """ + upc + """);
                        """
        cur = con.cursor()
        cur.execute(insert_query1)
        con.commit()

        insert_query2 = """ 
                            INSERT INTO wishlist("ListID", "UPC", "DesiredPrice") 
                            VALUES (""" + wishlistid + """, """ + upc + """, """ + targetprice + """);
                        """
        cur = con.cursor()
        cur.execute(insert_query2)    
        con.commit()
        return 'has been successfully added to the wishlist'

    #not unique item
    return 'already exists in the wishlist'

class RegisterForm(Form):
    name = StringField('Name', [validators.Length(min=1, max=100)])
    username = StringField('Username', [validators.Length(min=4, max=25)])
    email = StringField('Email', [validators.Length(min=6, max=50)])
    password = PasswordField('Password', [
        validators.DataRequired(),
        validators.EqualTo('confirm', message='passwords do not match')
    ])
    confirm = PasswordField('Confirm Password')

class UserForm(Form):
    name = StringField('Name', [validators.Length(min=1, max=100)])
    username = StringField('Username', [validators.Length(min=4, max=25)])
    email = StringField('Email', [validators.Length(min=6, max=50)])

class PasswordForm(Form):
    oldPassword = PasswordField('Password', [
        validators.DataRequired()
    ])
    password = PasswordField('Password', [
        validators.DataRequired(),
        validators.EqualTo('confirm', message='passwords do not match')
    ])


@app.route('/register', methods=['GET', 'POST'])
def register():
    form = RegisterForm(request.form)
    cursor = con.cursor()
    if request.method == 'POST' and form.validate():
        # cursor = con.cursor()
        name = form.name.data
        email = form.email.data
        username = form.username.data
        password = sha256_crypt.encrypt(str(form.password.data))

        cursor.execute("SELECT 1 FROM users WHERE username=%s AND email=%s", (username, email))
        con.commit()

        if cursor.rowcount == 1:
            flash('Username or email already exist', 'warning')
            return redirect(url_for('register'))
        else:
            cursor.execute("INSERT INTO users (username, Email, Password, Name) VALUES(%s, %s, %s, %s);",
                           (username, email, password, name))
            con.commit()
            flash('you are now register and can log in', 'success')
            return redirect(url_for('index'))
            print("raseres")

        cursor.close()
    return render_template('register.html', form=form)


@app.route('/login', methods=['GET', 'POST'])
def login():
    # global globalUsername
    if request.method == 'POST':
        username = request.form['username']
        password_candidate = request.form['password']

        cursor = con.cursor(cursor_factory=psycopg2.extras.DictCursor)

        result = cursor.execute("SELECT * FROM users WHERE username = %s", [username])
        result = cursor.fetchone()
        if result:
            # Get stored hash
            password = result['password']
            user_id = result['user_id']
            name = result['name']
            email = result['email']

            # Compare Passwords
            if sha256_crypt.verify(password_candidate, password):
                # Passed
                session['logged_in'] = True
                session['username'] = username
                session['user_id'] = user_id
                session['name'] = name
                session['email'] = email

                flash('You are now logged in', 'success')
                return redirect(url_for('dashboard'))
            else:
                error = 'Invalid login'
                return render_template('login.html', error=error)
            # Close connection
            cursor.close()
        else:
            error = 'Username not found'
            return render_template('login.html', error=error)
    return render_template('login.html')


# check is user is logged in
def is_logged_in(f):
    @wraps(f)
    def wrap(*args, **kwargs):
        if 'logged in' in session:
            return f(*args, **kwargs)
        else:
            flash('Unauthorized, Please login', 'danger')
            return redirect(url_for('login'))

    return wrap

# for home page of user
@app.route('/dashboard')
def dashboard():
    # trying to get values from database for shopping List
    result = session["user_id"]
    # showing list for shoppinglist
    curs.execute('SELECT list."Name",list."ListID" '
                 'FROM shoppinglist, list, users '
                 'WHERE list."ListID" = shoppinglist."ListID" '
                 'AND users.user_id = list."UserID"'
                 'AND users.user_id = %s ', [result])
    data = curs.fetchall()
    #showing lists for wishlist in ascending order
    curs.execute('SELECT L."Name", L."ListID" '
                 'FROM list L, users, shoppinglist '
                 'WHERE users.user_id = L."UserID" '
                 'AND users.user_id = %s AND L."ListID" <> ALL '
                 '(SELECT S."ListID"'
                 'FROM shoppinglist S)'
                 'GROUP BY L."Name", L."ListID"'
                 'ORDER BY L."Name" ASC ', [result])
    dataWish = curs.fetchall()  # data from the database
    return render_template('dashboard.html', value1=data, value2=dataWish)


# page to show all the items stored in shoppingList
@app.route('/dashboard/<int:id>/<string:name>/')
def shoppingList(id, name):
    curs.execute('SELECT variety."Brand",listitems."UPC", variety."Size", '
                 'variety."StorageType", particularproductpricing."Price", retailcompany."Name",'
                 ' retailcompany."Address" '
                 'FROM variety, listitems, particularproductpricing, retailcompany '
                 'WHERE listitems."ListID"= %s '
                 'AND variety."UPC" = listitems."UPC" '
                 'AND particularproductpricing."UPC" = listitems."UPC" '
                 'AND particularproductpricing."RetailID" = retailcompany."RetailID"', [id])
    data = curs.fetchall()
    return render_template('shoppingList.html', name=name, id=id, data = data)


# page to show all the items stored in wishList
@app.route('/dashboard/wishlist/<int:id>/<string:name>/')
def wishList(id, name):
    curs.execute('SELECT variety."Brand",listitems."UPC", variety."Size", '
                 'variety."StorageType", particularproductpricing."Price", retailcompany."Name",'
                 ' retailcompany."Address" '
                 'FROM variety, listitems, particularproductpricing, retailcompany '
                 'WHERE listitems."ListID"= %s '
                 'AND variety."UPC" = listitems."UPC" '
                 'AND particularproductpricing."UPC" = listitems."UPC" '
                 'AND particularproductpricing."RetailID" = retailcompany."RetailID"', [id])
    data = curs.fetchall()
    return render_template('wishList.html', name=name, id=id, data = data)

# edit page seperated as shoppingList does not have delete full list
# edit page for the shoppinglist
@app.route('/dashboard/<int:id>/<string:name>/edit')
def edit(id, name):
    curs.execute('SELECT variety."Brand",listitems."UPC", variety."Size", '
                 'variety."StorageType", particularproductpricing."Price", retailcompany."Name",'
                 ' retailcompany."Address" '
                 'FROM variety, listitems, particularproductpricing, retailcompany '
                 'WHERE listitems."ListID"= %s '
                 'AND variety."UPC" = listitems."UPC" '
                 'AND particularproductpricing."UPC" = listitems."UPC" '
                 'AND particularproductpricing."RetailID" = retailcompany."RetailID"', [id])
    data = curs.fetchall()
    return render_template('editShopping.html', name=name, id=id, data= data)


# edit page for the wishList
@app.route('/dashboard/<int:id>/<string:name>/wishlist/edit/')
def editWishList(id, name):
    curs.execute('SELECT variety."Brand",listitems."UPC", variety."Size", '
                 'variety."StorageType", particularproductpricing."Price", retailcompany."Name",'
                 ' retailcompany."Address" '
                 'FROM variety, listitems, particularproductpricing, retailcompany '
                 'WHERE listitems."ListID"= %s '
                 'AND variety."UPC" = listitems."UPC" '
                 'AND particularproductpricing."UPC" = listitems."UPC" '
                 'AND particularproductpricing."RetailID" = retailcompany."RetailID"', [id])
    data = curs.fetchall()
    return render_template('edit.html', name=name, id=id, data=data)


# to delete full list from database for wishlist
@app.route('/dashboard/<string:name>/edit/delete/wishlist')
def deleteFullList(name):
    curs.execute('SELECT 1 '
                 'FROM list '
                 'WHERE list."Name" = %s', [name])
    con.commit()
    if curs.rowcount == 1:
        curs.execute('DELETE FROM list WHERE list."Name" = %s', [name])
        flash('List deleted successfully', 'success')
        return redirect(url_for('dashboard'))
    else:
        flash('Error: A list with this name does not exist', 'warning')
        return redirect(url_for('dashboard'))


# to delete product from both shoppingList and WishList
# this is connected to both
@app.route('/dashboard/<int:id>/<int:upc>/<string:name>/edit/deleteProduct')
def deleteProductFromList(id, upc, name):
    curs.execute('DELETE FROM listitems WHERE listitems."ListID" = %s AND listitems."UPC" = %s', [id,upc])
    flash('Deleted product from list successfully', 'success')
    return redirect(url_for('dashboard'))


# adding new list to wishList
class AddNewList(Form):
    newListName = StringField('Name:', [validators.Length(min=1, max=1000)])

# adding new wishlist
@app.route('/addNewList', methods=['GET', 'POST'])
def addNewList():
    if request.method == 'POST':
        name = request.form['name']
        userId = session["user_id"]

        #making sure a name was added
        if name == "":
            flash('All fields need to be filled in', 'warning')
        else:
            curs.execute('INSERT INTO list ("Name", "UserID") VALUES(%s, %s);', (name, userId))
            con.commit()
            flash('List added successfully', 'success')
            return redirect(url_for('dashboard'))

    return render_template('addNewList.html')


@app.route('/logout')
def logout():
    session.clear()
    flash("you are now logged out", 'success')
    return redirect(url_for('login'))

@app.route('/profile', methods=['GET', 'POST'])
def profile():
    form = UserForm(request.form)
    cursor = con.cursor(cursor_factory=psycopg2.extras.DictCursor)
    if request.method == 'POST' and form.validate():
        name = form.name.data
        email = form.email.data
        username = form.username.data
        is_valid = validate_email(email)

        userId = session['user_id']
        oldName = session['name']
        oldEmail = session['email']
        oldUsername = session['username']

        if name != oldName:
            cursor.execute("UPDATE users SET name=%s WHERE user_id=%s ;", (name, userId))
            con.commit()

        if email != oldEmail:
            cursor.execute("SELECT 1 FROM users WHERE email=%s AND user_id !=%s;", (email, userId))
            con.commit()
            if cursor.rowcount >= 1:
                flash('email already exist', 'warning')
            elif is_valid == False:
                flash('Not valid email', 'warning')
            else:
                cursor.execute("UPDATE users SET email=%s WHERE user_id=%s ;", (email, userId))
                con.commit()
                flash('you have successfully changed your email', 'success')

        if username != oldUsername:
            cursor.execute("SELECT 1 FROM users WHERE username=%s AND user_id !=%s;", (username, userId))
            con.commit()
            if cursor.rowcount >= 1:
                flash('username already exist', 'warning')
            else:
                cursor.execute("UPDATE users SET username=%s WHERE user_id=%s ;", (username, userId))
                con.commit()
                flash('you have successfully changed your username', 'success')

        result = cursor.execute("SELECT * FROM users WHERE user_id = %s", [session['user_id']])
        result = cursor.fetchone()
        if result:
            # Get stored hash
            name = result['name']
            email = result['email']
            username = result['username']
            session['username'] = username
            session['name'] = name
            session['email'] = email
        cursor.close()
        return redirect(url_for('profile'))
    return render_template('profile.html', form=form)

@app.route('/password', methods=['GET', 'POST'])
def password():
    form = PasswordForm(request.form)
    userId = session['user_id']
    if request.method == 'POST':
        oldPass = request.form['old_password']
        newPass = request.form['new_password']
        newPass = sha256_crypt.encrypt(str(newPass))
        cursor = con.cursor(cursor_factory=psycopg2.extras.DictCursor)

        result = cursor.execute("SELECT * FROM users WHERE user_id = %s;", [userId])
        result = cursor.fetchone()
        if result:
            # Compare Passwords
            password = result['password']
            if sha256_crypt.verify(oldPass, password):
                # Passed
                session.clear()
                cursor.execute("UPDATE users SET password=%s WHERE user_id=%s ;", (newPass, userId))
                flash('You have change your password, Please login', 'success')
                session.clear()
                return redirect(url_for('login'))
            else:
                error = 'Wrong Password'
                return render_template('password.html', error=error)
            # Close connection
            cursor.close()
        else:
            error = 'Username not found'
            return render_template('login.html', error=error)


    return render_template('password.html', form=form)


if __name__ == '__main__':
    app.secret_key = 'secert123'
    app.run(debug=True)
