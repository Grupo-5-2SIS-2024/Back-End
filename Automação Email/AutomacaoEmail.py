import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from mysql.connector import connect, Error
import time

# Função para obter conexão com o MySQL
def mysql_connection(host, user, passwd, database=None):
    return connect(host=host, user=user, passwd=passwd, database=database)

# Função para enviar e-mails
def send_email(subject, body, recipient_email):
    sender_email = "pedro.pinto@sptech.school"
    password = "#Gf49147963840"
    smtp_server = "smtp-mail.outlook.com"
    port = 587

    message = MIMEMultipart()
    message["From"] = sender_email
    message["To"] = recipient_email
    message["Subject"] = subject

    message.attach(MIMEText(body, "html"))

    try:
        with smtplib.SMTP(smtp_server, port) as server:
            server.starttls()
            server.login(sender_email, password)
            server.sendmail(sender_email, recipient_email, message.as_string())
        print(f"Email enviado para {recipient_email}")
    except Exception as e:
        print(f"Erro ao enviar email para {recipient_email}: {e}")

# Função para criar o corpo do e-mail
def create_email_body(nome, nome_paciente, data_consulta, horario_consulta, duracao_consulta, message):
    return f"""
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Email Notificação</title>
    </head>
    <body style="margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f2f2f2;">
        <table border="0" cellpadding="0" cellspacing="0" width="100%" style="background-color: #f2f2f2;">
            <tr>
                <td align="center">
                    <table border="0" cellpadding="0" cellspacing="0" width="600" style="background-color: #ffffff;">
                        <tr>
                            <td align="center" style="padding: 40px 0;">
                                <img src="https://img.freepik.com/fotos-gratis/paisagem-de-nevoeiro-matinal-e-montanhas-com-baloes-de-ar-quente-ao-nascer-do-sol_335224-794.jpg" alt="Paisagem" width="400" style="display: block; margin: 0 auto;">
                                <p style="margin-top: 20px; text-align: center;">Olá, {nome}!</p>
                                <p style="text-align: center;">{message} <b>{nome_paciente}</b> foi marcada no dia {data_consulta} às {horario_consulta} com a duração de {duracao_consulta}.</p>
                                <p style="text-align: center;">Agradecemos por ter recebido este e-mail!</p>
                                <p style="text-align: center;">Favor não responder. Tenha um ótimo trabalho</p>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
    </html>
    """

# Função para checar e enviar e-mails
def check_and_send_emails(connection, interval_query, email_query, subject, email_message, sent_ids):
    try:
        cursor = connection.cursor()
        cursor.execute(interval_query)
        result = cursor.fetchall()

        if result:
            for id_consulta, data_consulta, duracao_consulta, horario_consulta, nome_paciente in result:
                if id_consulta not in sent_ids:
                    cursor.execute(email_query, (id_consulta,))
                    email_result = cursor.fetchall()

                    for email, nome in email_result:
                        body = create_email_body(nome, nome_paciente, data_consulta, horario_consulta, duracao_consulta, email_message)
                        send_email(subject, body, email)
                   
                    sent_ids.add(id_consulta)

    except Error as e:
        print(f"Erro ao executar consulta: {e}")
    finally:
        cursor.close()

def check_and_send_medico_emails(connection, email_query, email_message_template, sent_ids):
    try:
        cursor = connection.cursor()
        cursor.execute(email_query)
        email_result = cursor.fetchall()

        for email, nome, consultas_realizadas, consultas_totais in email_result:
            percentage = (consultas_realizadas / consultas_totais) * 100
            if percentage == 100:
                message = email_message_template['100%']
            elif 90 <= percentage < 100:
                message = email_message_template['90-99%']
            elif 60 <= percentage < 90:
                message = email_message_template['60-89%']
            elif 40 <= percentage < 60:
                message = email_message_template['40-59%']
            else:
                message = email_message_template['<40%']

            subject = 'Relatório de agendamentos'
            body = create_email_body(nome, '', '', '', '', message)
           
            if email not in sent_ids:
                send_email(subject, body, email)
                sent_ids.add(email)

    except Error as e:
        print(f"Erro ao executar consulta: {e}")
    finally:
        cursor.close()

def main():
    try:
        connection = mysql_connection('localhost', 'root', 'Pedroca12@', 'MultiClinics')
        sent_consulta_ids = set()
        sent_medico_ids = set()

        queries = [
            {
                'query': '''
                    SELECT c.id,
                           DATE_FORMAT(c.datahora_consulta, '%d/%m/%Y') AS DataConsulta,
                           TIME_FORMAT(c.duracao_consulta, '%H:%i') AS DuracaoConsulta,
                           TIME_FORMAT(c.datahora_consulta, '%H:%i') AS HoraConsulta,
                           p.nome AS NomePaciente
                    FROM consulta AS c
                    JOIN paciente AS p ON c.paciente = p.id
                    JOIN (
                        SELECT paciente, MIN(datahora_consulta) AS PrimeiraConsulta
                        FROM consulta
                        GROUP BY paciente
                        HAVING MIN(datahora_consulta) <= DATE_SUB(CURRENT_DATE, INTERVAL 11 MONTH)
                    ) pc ON c.paciente = pc.paciente AND c.datahora_consulta = pc.PrimeiraConsulta;
                ''',
                'subject': 'E-mail de alerta de 11 meses desde a última consulta',
                'message': 'Este é um e-mail para alertar que faz 11 meses desde a última consulta com'
            },
            {
                'query': '''
                    SELECT c.id,
                           DATE_FORMAT(c.datahora_consulta, '%d/%m/%Y') AS DataConsulta,
                           TIME_FORMAT(c.duracao_consulta, '%H:%i') AS DuracaoConsulta,
                           TIME_FORMAT(c.datahora_consulta, '%H:%i') AS HoraConsulta,
                           p.nome AS NomePaciente
                    FROM consulta AS c
                    JOIN paciente AS p ON c.paciente = p.id
                    WHERE DATE(c.datahora_consulta) = DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY);
                ''',
                'subject': 'E-mail de alerta de 1 semana antes do vencimento',
                'message': 'Este é um e-mail para alertar que falta uma semana para o vencimento da consulta com'
            },
            {
                'query': '''
                    SELECT c.id,
                           DATE_FORMAT(c.datahora_consulta, '%d/%m/%Y') AS DataConsulta,
                           TIME_FORMAT(c.duracao_consulta, '%H:%i') AS DuracaoConsulta,
                           TIME_FORMAT(c.datahora_consulta, '%H:%i') AS HoraConsulta,
                           p.nome AS NomePaciente
                    FROM consulta AS c
                    JOIN paciente AS p ON c.paciente = p.id
                    WHERE DATE(c.datahora_consulta) = DATE_SUB(CURRENT_DATE, INTERVAL 1 DAY);
                ''',
                'subject': 'E-mail de alerta de 24 horas antes do vencimento',
                'message': 'Este é um e-mail para alertar que falta 24 horas para o vencimento da consulta com'
            },
            {
                'query': '''
                    SELECT c.id,
                           DATE_FORMAT(c.datahora_consulta, '%d/%m/%Y') AS DataConsulta,
                           TIME_FORMAT(c.duracao_consulta, '%H:%i') AS DuracaoConsulta,
                           TIME_FORMAT(c.datahora_consulta, '%H:%i') AS HoraConsulta,
                           p.nome AS NomePaciente
                    FROM consulta AS c
                    JOIN paciente AS p ON c.paciente = p.id
                    WHERE DATE(c.datahora_consulta) = CURRENT_DATE;
                ''',
                'subject': 'E-mail de alerta para consultas do dia',
                'message': 'Este é um e-mail para alertar que hoje é o dia da consulta com'
            },
            {
                'query': '''
                    SELECT c.id,
                           DATE_FORMAT(c.datahora_consulta, '%d/%m/%Y') AS DataConsulta,
                           TIME_FORMAT(c.duracao_consulta, '%H:%i') AS DuracaoConsulta,
                           TIME_FORMAT(c.datahora_consulta, '%H:%i') AS HoraConsulta,
                           p.nome AS NomePaciente
                    FROM consulta AS c
                    JOIN paciente AS p ON c.paciente = p.id
                    WHERE DATE(c.datahora_consulta) = DATE_SUB(CURRENT_DATE, INTERVAL -7 DAY);
                ''',
                'subject': 'E-mail de alerta de uma semana após a consulta',
                'message': 'Este é um e-mail para alertar que já passou uma semana após a consulta com'
            },
        ]

        email_query = '''
            SELECT m.email, m.nome
            FROM medico AS m
            JOIN consulta AS c ON m.id = c.medico
            WHERE c.id = %s;
        '''

        medico_query = '''
            SELECT m.email, m.nome,
                COUNT(CASE WHEN c.id IS NOT NULL THEN 1 ELSE NULL END) AS consultas_realizadas,
                COUNT(*) AS consultas_totais
            FROM medico AS m
            LEFT JOIN consulta AS c ON m.id = c.medico AND MONTH(c.datahora_consulta) = MONTH(CURRENT_DATE)
            LEFT JOIN consulta AS a ON m.id = a.medico AND MONTH(a.datahora_consulta) = MONTH(CURRENT_DATE)
            GROUP BY m.id;
        '''

        email_message_template = {
            '100%': 'Parabéns, você alcançou 100% das suas consultas!',
            '90-99%': 'Você alcançou 90-99% das suas consultas.',
            '60-89%': 'Você alcançou 60-89% das suas consultas.',
            '40-59%': 'Você alcançou 40-59% das suas consultas.',
            '<40%': 'Você alcançou menos de 40% das suas consultas.'
        }

        while True:
            for query in queries:
                check_and_send_emails(connection, query['query'], email_query, query['subject'], query['message'], sent_consulta_ids)
           
            check_and_send_medico_emails(connection, medico_query, email_message_template, sent_medico_ids)
            time.sleep(60)  # Espera 1 minuto antes de repetir o while

    except Error as e:
        print(f"Erro de conexão: {e}")
    finally:
        if connection.is_connected():
            connection.close()

if __name__ == "__main__":
    main()
