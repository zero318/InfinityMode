# Infinity Mode Notes

## Cheats table structure
Each cheat in the cheat table has the following parameters:
- `type` (_string_) - One of _toggle_, _number_, or _action_.
- `default` (_boolean_, _number_, _string_) - The default value of the . <!-- - `default_lite` - The default value when initialized in **lite mode** -->
- `in_god_mode` (_boolean_) - If the cheat is applicable / editable in **God Mode**.
- `in_editor` (_boolean_) - If the cheat is applicable / editable while in the **Map Editor**.
- `functions` (_table_) - A table of functions for the cheat (see below).

### Cheat functions table
Each cheat has a `functions` parameter that contains a table of functions:
- `get_value(player)` - Must return the current value of the cheat.
- `value_changed(new_value)` - When the player changes the cheat setting through the GUI. The cheat's `value` parameter is set to the return value of this function.
- `setup_global(player, default_value)` (optional) - Return value is set as that cheat's data table in GLOBAL.

## Player table structure
- player_index
    - open_gui
        - element (LuaGuiElement)
        - location (concepts.position)
        - close_button (LuaGuiElement or nil)
        - data_to_destroy (string or nil)
    - cheats_gui
        - cur_player (LuaPlayer)
        - cur_force (LuaForce)
        - cur_surface (LuaSurface)
        - cur_tab (int)
    - ia_gui
        - entity (LuaEntity)
        - mode_dropdown (LuaGuiElement)
        - priority_dropdown (LuaGuiElement)
        - slider (LuaGuiElement)
        - slider_textfield (LuaGuiElement)
        - slider_dropdown (LuaGuiElement)
        - prev_textfield_value (int)