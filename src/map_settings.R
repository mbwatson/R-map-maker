## where are maps stored?
 map_location = "./maps/"

## what should each map be named?

    map_title = "Generic Map Title"

## map settings
 border_color = "#000000"
  water_color = "#0990BC"
outline_color = "#0990BC22"
   fill_color = "#FFFFFF"
    pin_color = "#00000066"

    map_width = 30
   map_height = 18
      map_dpi = 300
     map_unit = "cm"

map_theme <- list(theme(panel.grid.minor  = element_blank(),
                        panel.grid.major  = element_blank(),
                        panel.background  = element_rect(fill=water_color),
                        plot.background   = element_rect(fill=border_color),
                        panel.border      = element_blank(),
                        axis.line         = element_blank(),
                        axis.text.x       = element_blank(),
                        axis.text.y       = element_blank(),
                        axis.ticks        = element_blank(),
                        axis.title.x      = element_blank(),
                        axis.title.y      = element_blank(),
                        plot.title        = element_text(size=22,color=fill_color,family="Trebuchet MS")))


