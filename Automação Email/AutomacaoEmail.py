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
    sender_email = "pedro.pinto@sptech.school"  # Substitua pelo seu e-mail
    password = "#Gf49147963840"  # Substitua pela sua senha
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

# Função para enviar e-mails para pacientes
def check_and_send_patient_emails(connection, query, subject, message, sent_ids):
    try:
        cursor = connection.cursor()
        cursor.execute(query)
        result = cursor.fetchall()

        if result:
            for id_consulta, data_consulta, duracao_consulta, horario_consulta, nome_paciente, email, nome in result:
                if id_consulta not in sent_ids:
                    body = create_email_body(nome, nome_paciente, data_consulta, horario_consulta, duracao_consulta, message)
                    send_email(subject, body, email)
                    sent_ids.add(id_consulta)

    except Error as e:
        print(f"Erro ao executar consulta para pacientes: {e}")
    finally:
        cursor.close()

# Função para enviar e-mails para médicos
def check_and_send_medico_emails(connection, query, email_message_template, sent_ids):
    try:
        cursor = connection.cursor()
        cursor.execute(query)
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
        print(f"Erro ao executar consulta para médicos: {e}")
    finally:
        cursor.close()

def main():
    try:
        connection = mysql_connection('localhost', 'root', 'Pedroca12@', 'MultiClinics')
        sent_consulta_ids = set()
        sent_medico_ids = set()

        patient_queries = [
            {
                'query': '''
                    SELECT c.id,
                           DATE_FORMAT(c.datahora_consulta, '%d/%m/%Y') AS DataConsulta,
                           TIME_FORMAT(c.duracao_consulta, '%H:%i') AS DuracaoConsulta,
                           TIME_FORMAT(c.datahora_consulta, '%H:%i') AS HoraConsulta,
                           p.nome AS NomePaciente,
                           p.email,
                           p.nome
                    FROM consulta AS c
                    JOIN paciente AS p ON c.paciente = p.id
                    WHERE c.datahora_consulta <= DATE_SUB(CURRENT_DATE, INTERVAL 11 MONTH);
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
                           p.nome AS NomePaciente,
                           p.email,
                           p.nome
                    FROM consulta AS c
                    JOIN paciente AS p ON c.paciente = p.id
                    WHERE DATE(c.datahora_consulta) = DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY);
                ''',
                'subject': 'E-mail de alerta de 1 semana antes do vencimento',
                'message': 'Este é um e-mail para alertar que falta uma semana para o vencimento da consulta com'
            },
            # Adicione as outras regras para pacientes aqui
        ]

        medico_query = '''
            SELECT m.email, m.nome, 
                   COUNT(c.id) AS consultas_realizadas, 
                   (SELECT COUNT(*) FROM consulta WHERE medico = m.id) AS consultas_totais
            FROM medico AS m
            LEFT JOIN consulta AS c ON m.id = c.medico AND c.datahora_consulta BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH) AND CURRENT_DATE
            GROUP BY m.id;
        '''

        email_message_template = {
            '100%': 'Parabéns! Você realizou 100% das consultas agendadas neste mês.',
            '90-99%': 'Ótimo trabalho! Você realizou mais de 90% das consultas agendadas neste mês.',
            '60-89%': 'Bom trabalho! Você realizou entre 60% e 89% das consultas agendadas neste mês.',
            '40-59%': 'Atenção! Você realizou entre 40% e 59% das consultas agendadas neste mês.',
            '<40%': 'Alerta! Você realizou menos de 40% das consultas agendadas neste mês.'
        }

        while True:
            # Verifica e envia e-mails para pacientes
            for query_data in patient_queries:
                check_and_send_patient_emails(connection, query_data['query'], query_data['subject'], query_data['message'], sent_consulta_ids)

            # Verifica e envia e-mails para médicos
            check_and_send_medico_emails(connection, medico_query, email_message_template, sent_medico_ids)

            time.sleep(60)  # Intervalo de 1 minuto entre as verificações

    except Exception as e:
        print(f"Erro geral: {e}")
    finally:
        if connection and connection.is_connected():
            connection.close()

if __name__ == '__main__':
    main()
