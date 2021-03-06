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
     	<%= menu_page(assigns) %>
    <%= case @page do %>
     	<% "projects" -> %> <%= projects_page(assigns) %>
     	<% "live_chat" -> %> <%= plain_markdown(assigns, 'https://raw.githubusercontent.com/askasp/live_tea/main/Blag.md') %>
     	<% "led" -> %> <%= plain_markdown(assigns, 'https://gitlab.com/akselsk/led-thermometer/-/raw/master/README.md') %>
     	<% "nixops" -> %>
     	<%= nixops_page(assigns) %>
     	<% "es" -> %>
     	<%= home_made_es_page(assigns) %>
     	<% "live_md" -> %>
     	<%= plain_markdown(assigns,'https://gitlab.com/akselsk/live_markdown/-/raw/master/README.md') %>
      <% _ -> %>  <%= home_page(assigns) %>
    <% end %>
    """
  end

  def home_page(assigns) do
    ~L"""
    <p>
    I'm a norwegian software developer with a MSc in mathematics/robotics. I graduated in 2017 and my thesis was to develop real-time
    software to autonomously track underwater cables with an underwater robot.
    <a href="https://github.com/askasp/Cable_Localization_by_magnetomers/raw/6a9872a6925cc762305d256c68898638a9b5f148/Master%20(1).pdf"> Link to thesis</a>
    </p>

    <p>
    In work life I started in the "defence" sector, and moved on to working with payment infrastructure in a norwegian fintech called Vipps. Currently, I'm
    working at <a href="https://dignio.com"> Dignio </a>, a startup within remote care.  So the ethical aspect of my work is strictly increasing!
    </p>

    <p>
    My greatest achievements are taking 23  consecutive pull ups, and running a 5km on 17.16
    </p>

    """
  end

  def projects_page(assigns) do
    ~L"""
    <section>


    <%= project_page_intro(%{
    	image: false,
    	img: "https://i.imgur.com/NWaNe3l.png",
    	title: "Live chat with CQRS",
    	link: "/live_chat",
    	description: "
    	    How make a chatroom app using phoenix liveview and the CQRS pattern
    	    ",
    	git_link: "htts://gitlab.com/akselsk/live_tea",
    	demo_link: "livechat.stadler.no"

    	}) %>
    	


    <%= project_page_intro(%{
    	image: "/images/saunandtermo.png",
    	title: "Led Thermometer for Africa Burn",
    	link: "/led",
    	description: "
    	    In Africa burn 2019 we gifted a sauna to the community. We installed a 3m tall LED thermometer so bypassers could see the current sauna temperature. Here is a walkthrough of the code and how I wired it all up
    	    ",
    	git_link: "htts://gitlab.com/akselsk/led-thermometer",
    	demo_link: nil,

    	}) %>
    	
       <%= project_page_intro(%{
    	image: "/images/nixops.png",
    	title: "Nixops & Liveview",
    	link: "/nixops",
    	description: "Phoenix liveview is the new go-to framework for building SPAs in much the same way that 2021 is the year of the desktop (fingers crossed). Its killer feature is server-side-rendered dynamic webpages (it is as great as it sounds). Nixops is for people that are too cool for kubernetes",
    	git_link: nil,
    	demo_link: nil,

    	}) %>

       <%= project_page_intro(%{
    	image: "/images/telefon.svg",
    	title: "Koronavenn",
    	link: "https://kronavenn.web.app",
    	description: "Koronavenn A service made during the 2020 pandemic. The purpose was to connect quaranteened people so everyone had a call buddy or a 'corona-friend' (which is the title in Norwegian)",
    	git_link: nil,
    	demo_link: nil,

    	}) %>


       <%= project_page_intro(%{
    	image: "/images/markdow.jpg",
    	title: "Live Markdown (readme)",
    	link: "/live_md",
    	description: "Markdown to html service for liveview applications. Gets the markdown from an url, parses it, and stores the html inmemory for faster rendering",
    	git_link: "https://gitlab.com/akselsk/live_markdown",
    	demo_link: nil,

    	}) %>


       <%= project_page_intro(%{
    	image: "/images/stack.png",
    	title: "OTP eventstore",
    	link: "/es",
    	description: "A naive eventstore using buckets as storage. Support multible nodes by
    	              using a hash ring.
    	              Includes an even more naive cqrs module",
    	git_link: "https://gitlab.com/akselsk/otp_es",
    	demo_link: nil,
    	}) %>

    
    </section>
    """
  end

  def project_page_intro(assigns) do
    ~L"""
    <div class="flex flex-wrap mt-2 -mx-2">
    <div class="w-full lg:w-1/2 px-2 ">
    <%= if @image do %>
        <img class="w-full bg-koronavenn" src=" <%= Routes.static_path(StadlerNoWeb.Endpoint, @image)  %>"/>
    <% else %>
        <img class="w-full bg-koronavenn" src=" <%= @img %>"/>
    <% end %>

    </div>
    <div class="w-full lg:w-1/2  ">
    <%= live_patch @title, to: @link %>
    <p class="text-white opacity-67 text-sm mt-2"> <%= @description %> </p>

    <%= if @git_link  do %>
    </br>
     <a href="<%=@git_link%>" > Gitlab Repo </a>
     <% end %>

    <%= if @demo_link do %>
    </br>
     <a href="<%=@demo_link%>" > Demo </a>
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
