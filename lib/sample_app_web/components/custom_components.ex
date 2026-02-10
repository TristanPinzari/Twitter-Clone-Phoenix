defmodule SampleAppWeb.CustomComponents do
  use SampleAppWeb, :html

  def nav(assigns) do
    ~H"""
    <nav class="flex justify-between p-10 items-center">
      <h1 class="text-4xl font-semibold">Sample App</h1>
      <div class="flex items-center gap-12">
        <ul class="flex items-center gap-5 *:my-auto *:cursor-pointer *:hover:text-orange-500 font-extralight *:duration-250">
          <li><.link href={~p"/"}>Home</.link></li>
          <li><.link href={~p"/about"}>About</.link></li>
          <li><.link href={~p"/help"}>Help</.link></li>
          <li><.link href={~p"/contact"}>Contact</.link></li>
        </ul>
        <button class="bg-white text-black rounded-full py-2 px-8 text-lg cursor-pointer shadow-xl">
          Log in
        </button>
      </div>
    </nav>
    """
  end
end
