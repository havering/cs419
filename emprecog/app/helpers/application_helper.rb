module ApplicationHelper
  def lesc(text)
    LatexToPdf.escape_latex(text)
  end
end
