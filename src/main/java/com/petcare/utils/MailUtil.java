package com.petcare.utils;

import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

/** Sends email through Gmail SMTP (or any SMTP server) using an App Password. */
public final class MailUtil {

    private MailUtil() { }

    public static void send(String to, String subject, String htmlBody) throws MessagingException {
        String host = ConfigUtil.get("mail.smtp.host", "MAIL_SMTP_HOST", "smtp.gmail.com");
        String port = ConfigUtil.get("mail.smtp.port", "MAIL_SMTP_PORT", "587");
        String username = ConfigUtil.get("mail.smtp.username", "MAIL_SMTP_USERNAME", "");
        String password = ConfigUtil.get("mail.smtp.password", "MAIL_SMTP_PASSWORD", "");
        String from = ConfigUtil.get("mail.smtp.from", "MAIL_SMTP_FROM", username);
        if (username.isBlank() || password.isBlank()) {
            throw new MessagingException("Chưa cấu hình mail.smtp.username/mail.smtp.password.");
        }

        Properties props = new Properties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);
        props.put("mail.smtp.auth", ConfigUtil.get("mail.smtp.auth", "MAIL_SMTP_AUTH", "true"));
        props.put("mail.smtp.starttls.enable",
                ConfigUtil.get("mail.smtp.starttls.enable", "MAIL_SMTP_STARTTLS_ENABLE", "true"));

        Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        MimeMessage message = new MimeMessage(session);
        try {
            message.setFrom(new InternetAddress(from, "PetCare"));
        } catch (java.io.UnsupportedEncodingException e) {
            message.setFrom(new InternetAddress(from));
        }
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject, "UTF-8");
        message.setContent(htmlBody, "text/html; charset=UTF-8");
        Transport.send(message);
    }
}
