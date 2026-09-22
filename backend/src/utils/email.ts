import nodemailer from 'nodemailer';

/**
 * Email delivery: real SMTP when SMTP_HOST is configured,
 * otherwise console log (dev behavior). Never throws — auth flows
 * must not break because email is unavailable.
 */
export async function sendEmail(to: string, subject: string, body: string): Promise<void> {
  const { SMTP_HOST, SMTP_PORT, SMTP_USER, SMTP_PASS, SMTP_FROM } = process.env;
  if (!SMTP_HOST) {
    console.log(`[email] to=${to} subject=${subject}\n${body}`);
    return;
  }
  try {
    const transport = nodemailer.createTransport({
      host: SMTP_HOST,
      port: parseInt(SMTP_PORT ?? '587', 10),
      secure: (SMTP_PORT ?? '587') === '465',
      auth: SMTP_USER ? { user: SMTP_USER, pass: SMTP_PASS ?? '' } : undefined,
    });
    await transport.sendMail({ from: SMTP_FROM ?? 'noreply@katutubongpuno.ph', to, subject, text: body });
    console.log(`[email] sent to=${to} subject=${subject}`);
  } catch (err) {
    console.error('[email] SMTP failed, falling back to log', err);
  }
}
