
--[[


--]]

theme                               = {}

themes_dir                          = os.getenv("HOME") .. "/.config/awesome/themes/outputnoise"
-- theme.wallpaper                     = "/home/kim/Pictures/wallpapers/1418862243872.jpg"
theme.wallpaper 					= "/home/kim/Pictures/4chan related/waifu/lavren/1372595384349.jpg"

theme.font          = "Lemon 12"

theme.bg_normal     = "#222222"
theme.bg_focus      = "#222222"
theme.bg_urgent     = "#222222"
theme.bg_minimize   = "#222222"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#aaaaaa"

theme.border_width  = 1
theme.border_normal = "#292929"
theme.border_focus  = "#292929"
theme.border_marked = "#292929"

theme.layout_txt_tile               = "[t]"
theme.layout_txt_tileleft           = "[l]"
theme.layout_txt_tilebottom         = "[b]"
theme.layout_txt_tiletop            = "[tt]"
theme.layout_txt_fairv              = "[fv]"
theme.layout_txt_fairh              = "[fh]"
theme.layout_txt_spiral             = "[s]"
theme.layout_txt_dwindle            = "[d]"
theme.layout_txt_max                = "[m]"
theme.layout_txt_fullscreen         = "[F]"
theme.layout_txt_magnifier          = "[M]"
theme.layout_txt_floating           = "[|]"


theme.tasklist_disable_icon         = true
theme.tasklist_floating             = ""
theme.tasklist_maximized_horizontal = ""
theme.tasklist_maximized_vertical   = ""

-- lain related
theme.layout_txt_termfair           = "[termfair]"
theme.layout_txt_uselessfair        = "[ufv]"
theme.layout_txt_uselessfairh       = "[ufh]"
theme.layout_txt_uselessdwindle     = "[ud]"
theme.layout_txt_uselesstile        = "[ut]"

return theme
