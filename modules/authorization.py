import requests

from flask import Blueprint, render_template, request, redirect, url_for, session, current_app

from database.model import get_user


authorization = Blueprint('authorization', __name__, template_folder='../templates/authorization')


@authorization.route('/', methods=['GET'])
def index():
    return render_template('authorization.html', wrong_data=False)


@authorization.route('/', methods=['POST'])
def check_input():
    login = request.form.get('login')
    password = request.form.get('password')

    if 'is_external' in request.form:
        # Авторизация через API
        try:
            api_url = "http://127.0.0.1:5006/api/auth"
            payload = {'username': login, 'password': password}
            response = requests.post(api_url, json=payload)
            if response.status_code == 200:
                user_data = response.json()
                session['user_id'] = user_data['id']
                session['user_role'] = 'external'
                session['username'] = user_data['username']

                return redirect(url_for('index'))

            if response.status_code == 401:
                return render_template('authorization.html', wrong_data=True)

            else:
                return render_template('message.html', message='Ошибка сервера')

        except:
            return render_template('message.html', message='Авторизация внешних пользователей временно недоступна')


    else:
        result = get_user(login, password)

        if not result:
            return render_template('message.html', message='Возникла ошибка. Проверьте правильность SQL запроса')

        if result == 1:
            return render_template('message.html', message='Возникла ошибка при подключении к БД')

        elif result == 2:
            return render_template('authorization.html', wrong_data=True)

        else:
            session['user_id'] = result[0]
            session['user_role'] = result[1]
            return redirect(url_for('index'))
