defmodule Mix.Tasks.GenerateHighlightCss do
  @shortdoc "Generates CSS for syntax highlighting"
  @moduledoc false
  use Mix.Task

  alias Makeup.Styles.HTML.StyleMap

  def run(_) do
    css = Makeup.stylesheet(StyleMap.vim_style())

    output_path = Path.join(["assets", "css", "highlight.css"])
    File.write!(output_path, css)
    Mix.shell().info("Generated highlight.css in #{output_path}")
  end
end
