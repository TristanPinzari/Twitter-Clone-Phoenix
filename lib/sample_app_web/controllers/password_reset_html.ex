defmodule SampleAppWeb.PasswordResetHTML do
  import SampleAppWeb.CustomComponents
  use SampleAppWeb, :html

  embed_templates "../templates/password_reset_pages/*"
end
