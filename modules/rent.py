from datetime import date

from flask import Blueprint, render_template, request, session, redirect, url_for

import access

from database.model import get_billboards, finish_rent


rent = Blueprint('rent', __name__, template_folder='templates')


@rent.route('/', methods=['GET'])
@access.group_required
def index():
    """
    Попадаем в эту функцию при нажатии кнопки "Арендовать билборд" в главном меню
    """
    if session.get('selected_billboards'):
        session.pop('selected_billboards')

    return render_template('rent_index.html')


@rent.route('/', methods=['POST'])
@access.group_required
def time_selected():
    """
    Попадаем в эту функцию после ввода времени аренды билбордов.
    Она заносит в сессию информацию о всех билбордах (если ее там уже нет), которые можно арендовать за выбранную дату,
    получает список id всех билбордов, уже добавленных в корзину и на основе этих списков рендерит страницу
    """
    if request.form.get('end') < request.form.get('start') or request.form.get('start') < str(date.today()):
        return render_template('rent_index.html', wrong_data=True)

    session['start_date'] = request.form.get('start')
    session['end_date'] = request.form.get('end')

    available_billboards = get_billboards(session['start_date'], session['end_date'])

    if not available_billboards or type(available_billboards) == int:
        if available_billboards == 2:
            return render_template('message.html', message='Нет билбордов для аренды в заданную дату')
        return render_template('message.html', message='Ошибка в БД')

    session['available_billboards'] = available_billboards

    return redirect(url_for('rent.basket_index'))


@rent.route('/billboards', methods=['GET'])
@access.group_required
def basket_index():
    if not session.get('available_billboards'):
        return render_template('rent.index')

    available_billboards = session['available_billboards']
    selected_billboards_indexes = session.get('selected_billboards', set())
    selected_billboards = []
    not_selected_billboards = []

    print(available_billboards)
    print(selected_billboards)

    for i in range(len(available_billboards)):
        billboard_id = available_billboards[i][0]
        if billboard_id in selected_billboards_indexes:
            selected_billboards.append(available_billboards[i])
        else:
            not_selected_billboards.append(available_billboards[i])

    return render_template('rent_basket.html',
                           billboards=not_selected_billboards,
                           basket=selected_billboards)


@rent.route('/billboards', methods=['POST'])
@access.group_required
def basket_main():
    selected_billboards = set(session.get('selected_billboards', []))

    # Добавление билборда в корзину
    if request.form.get('buy'):
        selected_billboards.update({int(request.form['selected_billboard_id'])})

    # Удаление из корзины
    else:
        selected_billboards.remove(int(request.form['selected_billboard_id']))

    session['selected_billboards'] = list(selected_billboards)
    session.modified = True

    return redirect(url_for('rent.basket_index'))


@rent.route('/clear_basket')
@access.group_required
def clear_basket():
    if session.get('selected_billboards'):
        session.pop('selected_billboards')
    return redirect(url_for('rent.basket_index'))


@rent.route('/save_order')
@access.group_required
def save_order():
    if not session.get('available_billboards'):
        return render_template("message.html", message="Время сессии истекло либо вы ввели URL самостоятельно")
    if not session.get('selected_billboards'):
        return render_template("message.html", message="Вы не выбрали билборды")
    if not session.get('username'):
        return render_template("message.html", message="Вам недоступно оформление заказа")

    user_id = session.get('user_id')
    start = session.get('start_date')
    end = session.get('end_date')

    billboards = session['selected_billboards']


    result = finish_rent(user_id, start, end, billboards)

    if not result:
        return render_template('message.html', message='Произошла ошибка. Аренда не совершена')

    return render_template('status.html', id=result)
