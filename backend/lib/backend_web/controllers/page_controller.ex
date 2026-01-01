defmodule BackendWeb.PageController do
  use BackendWeb, :controller

  def index(conn, _params) do
    text(conn, "Backend is running!")
  end
end

