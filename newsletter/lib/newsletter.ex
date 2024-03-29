defmodule Newsletter do
  def read_emails(path), do:
    File.read!(path) |> String.split("\n", [trim: true])

  def open_log(path), do: File.open!(path, [:write])

  def log_sent_email(pid, email), do: IO.puts(pid, email)

  def close_log(pid), do: File.close(pid)

  def send_newsletter(emails_path, log_path, send_fun) do
    emails = read_emails(emails_path)
    log_pid = open_log(log_path)

    # Enum.each(emails, fn email ->
    #   if :ok == send_fun.(email) do
    #     log_sent_email(log_pid, email)
    #   end
    # end)

    emails
    |> Enum.map(& send_fun.(&1) == :ok and log_sent_email(log_pid, &1))

    close_log(log_pid)
  end
end
