#!/usr/bin/env python3
import smtplib
from email.mime.text import MIMEText
import argparse

sender = 'ggggggg22815@gmail.com'
receiver = 'zhenya.eww@gmail.com'

parser = argparse.ArgumentParser(description='письма.')
parser.add_argument('--subject', type=str, required=True, help='Тема письма')
parser.add_argument('--body', type=str, required=True, help='Тело письма')

args = parser.parse_args()

subject = args.subject
body = args.body

msg = MIMEText(body)
msg['Subject'] = subject
msg['From'] = sender
msg['To'] = receiver

try:
    with smtplib.SMTP('smtp.gmail.com', 587) as server:
        server.starttls()
        server.login(sender, 'skbh muke mfrg yxbq')  
        server.sendmail(sender, receiver, msg.as_string())
    print("Письмо успешно отправлено!")
except Exception as e:
    print(f"Ошибка при отправке письма: {e}")