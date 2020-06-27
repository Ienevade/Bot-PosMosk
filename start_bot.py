import telebot
from telebot import apihelper


def start():
    PROXY = 'socks5://127.0.0.1:9050'
    apihelper.proxy = {'https': PROXY}
    bot = telebot.TeleBot('1048945938:AAHX_0SBJJhwaXkzj-n7OxlFlsxaK6vvFHU')
    return bot
