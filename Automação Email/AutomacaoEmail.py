import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from mysql.connector import connect, Error
import time

# Função para obter conexão com o MySQL
def conexao_mysql(host, usuario, senha, banco=None):
    return connect(host=host, user=usuario, passwd=senha, database=banco)

# Função para enviar e-mails
def enviar_email(assunto, corpo, email_destinatario):
    email_remetente = "seuemail@exemplo.com"  # Substitua pelo seu e-mail
    senha = "suasenha"  # Substitua pela sua senha
    servidor_smtp = "smtp-mail.outlook.com"
    porta = 587

    mensagem = MIMEMultipart()
    mensagem["From"] = email_remetente
    mensagem["To"] = email_destinatario
    mensagem["Subject"] = assunto

    mensagem.attach(MIMEText(corpo, "html"))

    try:
        with smtplib.SMTP(servidor_smtp, porta) as servidor:
            servidor.starttls()
            servidor.login(email_remetente, senha)
            servidor.sendmail(email_remetente, email_destinatario, mensagem.as_string())
        print(f"E-mail enviado para {email_destinatario}")
    except Exception as e:
        print(f"Erro ao enviar e-mail para {email_destinatario}: {e}")

# Função para criar o corpo do e-mail
def criar_corpo_email(nome, nome_paciente, data_consulta, horario_consulta, duracao_consulta, mensagem):
    return f"""
    <!DOCTYPE html>
    <html lang="pt">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Notificação por E-mail</title>
    </head>
    <body style="margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f2f2f2;">
        <table border="0" cellpadding="0" cellspacing="0" width="100%" style="background-color: #f2f2f2;">
            <tr>
                <td align="center">
                    <table border="0" cellpadding="0" cellspacing="0" width="600" style="background-color: #ffffff;">
                        <tr>
                            <td align="center" style="padding: 40px 0;">
                                <p style="margin-top: 20px; text-align: center;">Olá, {nome}!</p>
                                <p style="text-align: center;">{mensagem} <b>{nome_paciente}</b> foi marcada no dia {data_consulta} às {horario_consulta} com a duração de {duracao_consulta}.</p>
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
def verificar_enviar_emails_pacientes(conexao, consulta, assunto, mensagem, ids_enviados):
    try:
        cursor = conexao.cursor()
        cursor.execute(consulta)
        resultado = cursor.fetchall()

        if resultado:
            for id_consulta, data_consulta, duracao_consulta, horario_consulta, nome_paciente, email, nome in resultado:
                if id_consulta not in ids_enviados:
                    corpo = criar_corpo_email(nome, nome_paciente, data_consulta, horario_consulta, duracao_consulta, mensagem)
                    enviar_email(assunto, corpo, email)
                    ids_enviados.add(id_consulta)

    except Error as e:
        print(f"Erro ao executar consulta para pacientes: {e}")
    finally:
        cursor.close()

# Função para enviar e-mails para médicos
def verificar_enviar_emails_medicos(conexao, consulta, modelo_mensagem_email, ids_enviados):
    try:
        cursor = conexao.cursor()
        cursor.execute(consulta)
        resultado_email = cursor.fetchall()

        for email, nome, consultas_realizadas, consultas_totais in resultado_email:
            porcentagem = (consultas_realizadas / consultas_totais) * 100
            if porcentagem == 100:
                mensagem = modelo_mensagem_email['100%']
            elif 90 <= porcentagem < 100:
                mensagem = modelo_mensagem_email['90-99%']
            elif 60 <= porcentagem < 90:
                mensagem = modelo_mensagem_email['60-89%']
            elif 40 <= porcentagem < 60:
                mensagem = modelo_mensagem_email['40-59%']
            else:
                mensagem = modelo_mensagem_email['<40%']

            assunto = 'Relatório de agendamentos'
            corpo = criar_corpo_email(nome, '', '', '', '', mensagem)

            if email not in ids_enviados:
                enviar_email(assunto, corpo, email)
                ids_enviados.add(email)

    except Error as e:
        print(f"Erro ao executar consulta para médicos: {e}")
    finally:
        cursor.close()

def principal():
    try:
        conexao = conexao_mysql('localhost', 'root', 'sua_senha', 'MultiClinics')
        ids_consulta_enviados = set()
        ids_medico_enviados = set()

        consultas_pacientes = [
            {
                'consulta': '''
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
                'assunto': 'E-mail de alerta de 11 meses desde a última consulta',
                'mensagem': 'Este é um e-mail para alertar que faz 11 meses desde a última consulta com'
            },
            {
                'consulta': '''
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
                'assunto': 'E-mail de alerta de 1 semana antes do vencimento',
                'mensagem': 'Este é um e-mail para alertar que falta uma semana para o vencimento da consulta com'
            },
            # Adicione as outras regras para pacientes aqui
        ]

        consulta_medico = '''
            SELECT m.email, m.nome, 
                   COUNT(c.id) AS consultas_realizadas, 
                   (SELECT COUNT(*) FROM consulta WHERE medico = m.id) AS consultas_totais
            FROM medico AS m
            LEFT JOIN consulta AS c ON m.id = c.medico AND c.datahora_consulta BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH) AND CURRENT_DATE
            GROUP BY m.id;
        '''

        modelo_mensagem_email = {
            '100%': 'Parabéns! Você realizou 100% das consultas agendadas neste mês.',
            '90-99%': 'Ótimo trabalho! Você realizou mais de 90% das consultas agendadas neste mês.',
            '60-89%': 'Bom trabalho! Você realizou entre 60% e 89% das consultas agendadas neste mês.',
            '40-59%': 'Atenção! Você realizou entre 40% e 59% das consultas agendadas neste mês.',
            '<40%': 'Alerta! Você realizou menos de 40% das consultas agendadas neste mês.'
        }

        while True:
            # Verifica e envia e-mails para pacientes
            for dados_consulta in consultas_pacientes:
                verificar_enviar_emails_pacientes(conexao, dados_consulta['consulta'], dados_consulta['assunto'], dados_consulta['mensagem'], ids_consulta_enviados)

            # Verifica e envia e-mails para médicos
            verificar_enviar_emails_medicos(conexao, consulta_medico, modelo_mensagem_email, ids_medico_enviados)

            time.sleep(60)  # Intervalo de 1 minuto entre as verificações

    except Exception as e:
        print(f"Erro geral: {e}")
    finally:
        if conexao and conexao.is_connected():
            conexao.close()

if __name__ == '__main__':
    principal()