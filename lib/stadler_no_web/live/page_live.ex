defmodule StadlerNoWeb.PageLive do
  use StadlerNoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    
    {:ok, assign(socket, page: "home", previous_page: false)}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    case params["page"] do
      [] -> {:noreply, assign(socket, page: "home")}
      [x] -> {:noreply, assign(socket, page: x)}
      _  -> {:noreply, socket}
    end
  end


  def handle_event(event, a, socket) do
    new_socket =
      case event do
        "toggle-menu" -> handle_menu_toggle(socket)
        "nav-home" -> push_patch(socket, to: "/home")
        "nav-projects" -> push_patch(socket, to: "/projects")
        "nav-led" -> push_patch(socket, to: "/led")
        "nav-nixops" -> push_patch(socket, to: "/nixops")
        _ -> socket
      end

    {:noreply, new_socket}
  end

  def render(assigns) do
    ~L"""
    <%= case @page do %>
     	<% "home" -> %>
     	<%= menu_page(assigns) %>
     	<% "projects" -> %>
        <%= menu_page(assigns) %>
     	<%= projects_page(assigns) %>
     	<% "led" -> %>
            <%= menu_page(assigns) %>
     	    <%= africa_burn(assigns) %>
     	<% "nixops" -> %>
        <%= menu_page(assigns) %>
     	<%= nixops_page(assigns) %>
     	<% "es" -> %>
        <%= menu_page(assigns) %>
     	<%= home_made_es_page(assigns) %>

     	<% "live_md" -> %>
        <%= menu_page(assigns) %>
     	<%= plain_markdown(assigns,'https://gitlab.com/akselsk/live_markdown/-/raw/master/README.md') %>
      <% _ -> %>  <% home_page(assigns) %>
    <% end %>
    """
  end

  def home_page(assigns) do
    ~L"""
      <div class="text-center">
      	<h1 style="border: 0px;" class="text-yellow-500 text-3xl">Aksel Stadler</h1>
      	<h1 style="border: 0px;" class="text-white opacity-67 text-sm ">Robotics Engineer & Programmer</h1>
      </div>
      <%= menu_page(assigns) %>

    """
  end

  def projects_page(assigns) do
    ~L"""
    <section>
    <%= project_page_intro(%{
    	image: "/images/saunandtermo.png",
    	title: "Led Thermometer for Africa Burn",
    	link: "/led",
    	description: "
    	    In Africa burn 2019 we gifted a sauna to the community. We installed a 3m tall LED thermometer so bypassers could see the current sauna temperature. Here is a walkthrough of the code and how I wired it all up
    	    ",
    	git_link: "htts://gitlab.com/akselsk/led-thermometer",

    	}) %>
    	
       <%= project_page_intro(%{
    	image: "/images/nixops.png",
    	title: "Nixops & Liveview",
    	link: "/nixops",
    	description: "Phoenix liveview is the new go-to framework for building SPAs in much the same way that 2021 is the year of the desktop (fingers crossed). Its killer feature is server-side-rendered dynamic webpages (it is as great as it sounds). Nixops is for people that are too cool for kubernetes",
    	git_link: nil,

    	}) %>

       <%= project_page_intro(%{
    	image: "/images/telefon.svg",
    	title: "Koronavenn",
    	link: "https://kronavenn.web.app",
    	description: "Koronavenn A service made during the 2020 pandemic. The purpose was to connect quaranteened people so everyone had a call buddy or a 'corona-friend' (which is the title in Norwegian)",
    	git_link: nil,

    	}) %>


       <%= project_page_intro(%{
    	image: "/images/markdow.jpg",
    	title: "Live Markdown (readme)",
    	link: "/live_md",
    	description: "Markdown to html service for liveview applications. Gets the markdown from an url, parses it, and stores the html inmemory for faster rendering",
    	git_link: "https://gitlab.com/akselsk/live_markdown"

    	}) %>


       <%= project_page_intro(%{
    	image: "/images/stack.png",
    	title: "OTP eventstore",
    	link: "/es",
    	description: "A naive eventstore using buckets as storage. Support multible nodes by
    	              using a hash ring.
    	              Includes an even more naive cqrs module",
    	git_link: "https://gitlab.com/akselsk/otp_es",
    	}) %>

    
    </section>
    """
  end

  def project_page_intro(assigns) do
    ~L"""
    <div class="flex flex-wrap mt-2 -mx-2">
    <div class="w-full lg:w-1/2 px-2 ">
    <img class="w-full bg-koronavenn" src=" <%= Routes.static_path(StadlerNoWeb.Endpoint, @image)  %>"/>
    </div>
    <div class="w-full lg:w-1/2  ">
    <%= live_patch @title, to: @link %>
    <p class="text-white opacity-67 text-sm mt-2"> <%= @description %> </p>

    <%= if @git_link  do %>
    </br>
     <a href="<%=@git_link%>" > Gitlab Repo </a>
     <% end %>


    </div>    
    </div>    
    """
    end


  def menu_page(assigns) do
    ~L"""

      <div class="text-center">
      	<h1 style="border: 0px;" class="text-yellow-500 text-3xl">Aksel Stadler</h1>
      	<h1 style="border: 0px;" class="text-white opacity-67 text-sm ">Robotics Engineer & Programmer</h1>
      </div>

    <div class="nav-links">
      <a phx-click="nav-home"> Home </a>
      <a phx-click="nav-projects"
      <%= if @page =="projects" do %>
          class="text-stadler"
          <% end %>
          >

        Projects</a>
      </div>
     <hr class="border-solid border-yellow-500 mb-4"> </hr>

    """
  end



  def plain_markdown(assigns, path) do
      ~L"""
        <%= raw(LiveMarkdown.html_from_md_path(path)) %>
     """

  end

  def home_made_es_page(assigns) do
      ~L"""
        <%= raw(LiveMarkdown.html_from_md_path("https://gitlab.com/akselsk/otp_es/-/raw/master/README.md")) %>
     """
  end

  def africa_burn(assigns) do
      ~L"""
        <%= raw(LiveMarkdown.html_from_md_path('https://gitlab.com/akselsk/led-thermometer/-/raw/master/README.md')) %>
     """
  end
  def nixops_page(assigns) do
      Phoenix.View.render(StadlerNoWeb.PageView, "nixops.html", assigns)
  end

   
  defp handle_menu_toggle(socket) do
    case socket.assigns.page do
      "menu" ->
        if socket.assigns.previous_page do
          push_patch(socket, to: "/" <> socket.assigns.previous_page)
        else
          push_patch(socket, to: "/home")
        end

      x ->
        assign(socket, previous_page: x) |> push_patch(to: "/menu")
    end
  end
end
