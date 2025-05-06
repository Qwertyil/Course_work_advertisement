"""
app.py
"""
from flask import Flask, render_template, session, redirect, url_for

from modules.authorization import authorization
from modules.query import query
from modules.report import report
from modules.rent import rent


app = Flask(__name__)

app.secret_key = 'you will never guess'

# Регистрируем все blueprint'ы
app.register_blueprint(authorization, url_prefix='/authorization')
app.register_blueprint(query, url_prefix='/query')
app.register_blueprint(report, url_prefix='/report')
app.register_blueprint(rent, url_prefix='/rent')


@app.route('/')
def index():
    if 'user_role' in session and session.get('user_role') != 'external':
        message = f'Вы авторизованы как {session.get('user_role')}'
        return render_template('internal_menu.html', message=message)

    if session.get('user_role') == 'external':
        message = f'Вы авторизованы как {session.get('username')}'
        return render_template('external_menu.html', message=message)

    return redirect(url_for('authorization.index'))


@app.route('/coming_soon')
def coming_soon():
    return render_template('message.html', message='В разработке')


@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('index'))


if __name__ == '__main__':
    app.run(debug=True, port=5001)
