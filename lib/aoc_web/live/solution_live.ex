defmodule AocWeb.SolutionLive do
  @moduledoc false
  use AocWeb, :live_view

  alias Aoc.Solver

  def mount(%{"year" => year, "day" => day}, _session, socket) do
    year = String.to_integer(year)
    day = String.to_integer(day)

    problem = Solver.get_problem!(year, day)
    solution_code = Solver.get_solution_source_code(year, day)
    highlighted_code = AocWeb.SyntaxHighlighter.higlight("\n" <> solution_code, "elixir")
    input = Solver.fetch_input(year, day)
    adjacent_solutions = Solver.get_adjacent_solutions(year, day)

    {:ok,
     assign(socket,
       year: year,
       day: day,
       problem: problem,
       solution_code: highlighted_code,
       input: input,
       part: "silver",
       result: nil,
       solve_time: nil,
       error: nil,
       prev_solution: adjacent_solutions.prev,
       next_solution: adjacent_solutions.next
     )}
  end

  def handle_event("solve", %{"part" => part}, socket) do
    start_time = System.monotonic_time(:millisecond)

    task =
      Task.async(fn ->
        Solver.solve_problem(
          socket.assigns.year,
          socket.assigns.day,
          String.to_existing_atom(part)
        )
      end)

    case Task.yield(task, 60_000) || Task.shutdown(task) do
      {:ok, result} ->
        end_time = System.monotonic_time(:millisecond)
        solve_time = end_time - start_time
        {:noreply, assign(socket, result: result, part: part, solve_time: solve_time, error: nil)}

      nil ->
        {:noreply,
         assign(socket,
           result: nil,
           error: "Solution timed out after 60 seconds",
           solve_time: nil
         )}

      {:exit, reason} ->
        {:noreply,
         assign(socket,
           result: nil,
           error: "Solution failed: #{inspect(reason)}",
           solve_time: nil
         )}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-5xl mx-auto px-4 py-8 space-y-8 font-mono">
      <!-- Navigation Header -->
      <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-cyber-primary/30 pb-4 bg-cyber-black/80 backdrop-blur-sm sticky top-0 z-50">
        <div class="flex items-center gap-6">
          <.link
            navigate={~p"/"}
            class="group flex items-center gap-2 text-cyber-secondary hover:text-cyber-primary transition-colors"
          >
            <span class="text-lg group-hover:-translate-x-1 transition-transform">&lt;</span>
            <span class="uppercase tracking-widest text-sm">Root</span>
          </.link>

          <div class="h-8 w-px bg-cyber-primary/20"></div>

          <div class="flex items-center gap-4">
            <%= if @prev_solution do %>
              <.link
                navigate={~p"/solutions/#{elem(@prev_solution, 0)}/#{elem(@prev_solution, 1)}"}
                class="text-cyber-secondary/50 hover:text-cyber-primary hover:drop-shadow-neon-green transition-all"
                title="Previous Day"
              >
                &lt; Day_<%= String.pad_leading("#{elem(@prev_solution, 1)}", 2, "0") %>
              </.link>
            <% end %>

            <h1 class="text-2xl md:text-3xl font-bold text-transparent bg-clip-text bg-gradient-to-r from-cyber-primary to-cyber-secondary drop-shadow-neon-green">
              Y<%= @year %>_D<%= String.pad_leading("#{@day}", 2, "0") %>
            </h1>

            <%= if @next_solution do %>
              <.link
                navigate={~p"/solutions/#{elem(@next_solution, 0)}/#{elem(@next_solution, 1)}"}
                class="text-cyber-secondary/50 hover:text-cyber-primary hover:drop-shadow-neon-green transition-all"
                title="Next Day"
              >
                Day_<%= String.pad_leading("#{elem(@next_solution, 1)}", 2, "0") %> &gt;
              </.link>
            <% end %>
          </div>
        </div>

        <div class="flex items-center gap-4 text-xs text-cyber-secondary uppercase tracking-widest">
          <.link
            href={@problem.problem_url}
            target="_blank"
            class="hover:text-cyber-accent hover:underline decoration-cyber-accent/50 underline-offset-4 transition-colors"
          >
            [Source_Transmission]
          </.link>
        </div>
      </div>

      <div class="relative min-h-screen">
        <!-- Code Viewer (Main Content) -->
        <div class="w-full">
          <div class="relative border border-cyber-secondary shadow-neon-blue rounded-lg overflow-hidden h-full min-h-[80vh] crt-display">
            <div class="flex items-center justify-between bg-cyber-gray/50 px-4 py-2 border-b border-cyber-secondary/30 relative z-10">
              <div class="flex gap-2">
                <div class="w-3 h-3 rounded-full bg-red-500/50"></div>
                <div class="w-3 h-3 rounded-full bg-yellow-500/50"></div>
                <div class="w-3 h-3 rounded-full bg-green-500/50"></div>
              </div>
              <div class="text-xs text-cyber-secondary uppercase tracking-widest">
                Source_Code_Viewer_v1.0
              </div>
            </div>

            <div class="p-0 overflow-x-auto h-full custom-scrollbar">
              <pre class="highlight p-6 text-sm font-mono leading-relaxed"><%= @solution_code %></pre>
            </div>
            <!-- Decorative corner pieces -->
            <div class="absolute bottom-0 right-0 w-4 h-4 border-b-2 border-r-2 border-cyber-secondary">
            </div>
            <div class="absolute bottom-0 left-0 w-4 h-4 border-b-2 border-l-2 border-cyber-secondary">
            </div>
          </div>
        </div>
        <!-- Control Panel (Sidebar) -->
        <div class="mt-8 lg:mt-0 lg:absolute lg:top-0 lg:-right-[14rem] lg:w-48 z-20">
          <!-- Cyberpunk Connector (Desktop Only) -->
          <div class="hidden lg:block absolute top-12 -left-8 w-8 h-24 pointer-events-none z-0">
            <!-- Structural Arms -->
            <div class="absolute top-0 w-full h-1 bg-cyber-secondary/50 shadow-[0_0_5px_#00b8ff]">
            </div>
            <div class="absolute bottom-0 w-full h-1 bg-cyber-secondary/50 shadow-[0_0_5px_#00b8ff]">
            </div>
            <!-- Data Conduits -->
            <div class="absolute top-1/2 -translate-y-1/2 w-full flex flex-col gap-2 px-1">
              <div class="h-[2px] w-full bg-cyber-secondary/30 animate-data-flow"></div>
              <div class="h-[1px] w-full bg-cyber-secondary/50"></div>
              <div class="h-[2px] w-full bg-cyber-secondary/30 animate-data-flow-reverse"></div>
            </div>
            <!-- Background plate behind wires -->
            <div class="absolute inset-y-2 inset-x-2 bg-cyber-black/80 -z-10"></div>
          </div>
          <!-- Execution Module -->
          <div class="relative p-3 border border-cyber-secondary bg-cyber-black/90 shadow-neon-blue rounded-lg overflow-hidden group z-10">
            <div class="absolute top-0 left-0 px-2 py-1 text-[10px] bg-cyber-secondary text-cyber-black font-bold">
              EXEC_MODULE
            </div>
            <div class="absolute top-2 right-2 w-2 h-2 rounded-full bg-cyber-secondary animate-pulse">
            </div>

            <.form :let={f} for={%{}} as={:solution} phx-submit="solve" class="space-y-6 mt-4">
              <div class="space-y-2">
                <label class="text-xs text-cyber-secondary uppercase tracking-widest">
                  Target_Part
                </label>
                <div class="flex flex-col gap-2">
                  <label class="flex-1 cursor-pointer">
                    <input
                      type="radio"
                      name="part"
                      value="silver"
                      checked={@part == "silver"}
                      class="peer sr-only"
                    />
                    <div class="text-center py-2 border border-cyber-secondary/50 text-cyber-secondary peer-checked:bg-cyber-secondary peer-checked:text-cyber-black peer-checked:border-cyber-secondary transition-all hover:bg-cyber-secondary/20">
                      SILVER
                    </div>
                  </label>
                  <label class="flex-1 cursor-pointer">
                    <input
                      type="radio"
                      name="part"
                      value="gold"
                      checked={@part == "gold"}
                      class="peer sr-only"
                    />
                    <div class="text-center py-2 border border-cyber-warning/50 text-cyber-warning peer-checked:bg-cyber-warning peer-checked:text-cyber-black peer-checked:border-cyber-warning transition-all hover:bg-cyber-warning/20">
                      GOLD
                    </div>
                  </label>
                </div>
              </div>

              <.button
                type="submit"
                class="w-full py-3 relative overflow-hidden group bg-cyber-gray border border-cyber-secondary text-cyber-secondary font-bold tracking-widest hover:bg-cyber-secondary hover:text-cyber-black transition-all duration-300 shadow-[0_0_10px_rgba(0,184,255,0.3)] hover:shadow-[0_0_20px_rgba(0,184,255,0.6)]"
                phx-disable-with="PROCESSING..."
              >
                <span class="relative z-10">SOLVE</span>
              </.button>
            </.form>
            <!-- Status Display -->
            <div class="mt-4 pt-4 border-t border-cyber-secondary/30">
              <%= if @error do %>
                <div class="p-4 border border-red-500/50 bg-red-900/20 text-red-400 text-sm font-mono animate-pulse">
                  <span class="font-bold">CRITICAL_FAILURE:</span> <%= @error %>
                </div>
              <% end %>

              <%= if @result do %>
                <div class="space-y-2">
                  <div class="flex justify-between text-xs text-cyber-secondary uppercase">
                    <span>Execution_Time</span>
                    <span class="text-cyber-secondary"><%= @solve_time %>ms</span>
                  </div>
                  <div class="p-4 border border-cyber-secondary/50 bg-cyber-secondary/10 text-cyber-secondary text-lg font-bold break-all shadow-[inset_0_0_20px_rgba(0,184,255,0.1)]">
                    > <%= @result %>_
                  </div>
                </div>
              <% else %>
                <div class="text-center text-cyber-secondary/30 text-xs">
                  WAITING_FOR_INPUT...
                </div>
              <% end %>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
