local pti_ref = {
    input = 1,
    output = 2,
    buffer = 3,
    primary = 1,
    secondary = 2,
    tertiary = 3
}

local power_prefixes = {'kilo','mega','giga','tera','peta','exa','zetta','yotta'}
local power_suffixes_by_mode = {'watt','watt','joule'}

local function get_ia_options(entity)
    local name = entity.name:gsub('(%a+)-(%a+)-', '')
    if name == 'tertiary' then return {mode=3, priority=3} end
    local _,_,priority,mode = string.find(name, '(%a+)-(%a+)')
    return {mode=pti_ref[mode], priority=pti_ref[priority]}
end

local function create_dropdown(parent, name, caption, tooltip, items, selected_index, button_disabled)
    local flow = parent.add{type='flow', name=name..'_flow', style='vertically_centered_flow', direction='horizontal'}
    flow.add{type='label', name=name..'_label', caption=caption, tooltip=tooltip}
    flow.add {type='empty-widget', name=name..'_filler', style='invisible_horizontal_filler'}

    return flow.add{type='drop-down', name=name..'_dropdown', items=items, selected_index=selected_index}
end

local page = {}

function page.create(content_frame, data)
    local entity = data.entity
    local elems = {}
    local mode = get_ia_options(entity).mode
    local priority = get_ia_options(entity).priority

    local page_frame = content_frame.add{type='frame', name='im_ia_page_frame', style='entity_dialog_page_frame', direction='vertical'}

    -- SETTINGS
    
    elems.mode_dropdown = create_dropdown(page_frame, 'im_ia_mode',
        {'', {'gui-infinity-accumulator.mode-label-caption'}, ' [img=info]'}, {'gui-infinity-accumulator.mode-label-tooltip'}, {{'gui-infinity-accumulator.mode-dropdown-input'}, {'gui-infinity-accumulator.mode-dropdown-output'}, {'gui-infinity-accumulator.mode-dropdown-buffer'}}, mode)

    elems.priority_dropdown = create_dropdown(page_frame, 'im_ia_priority',
        {'', {'gui-infinity-accumulator.priority-label-caption'}, ' [img=info]'}, {'gui-infinity-accumulator.priority-label-tooltip'}, {{'gui-infinity-accumulator.priority-dropdown-primary'}, {'gui-infinity-accumulator.priority-dropdown-secondary'}, {'gui-infinity-accumulator.priority-dropdown-tertiary'}}, priority)

    page_frame.im_ia_priority_flow.style.vertically_stretchable = true

    if mode == 3 then
        elems.priority_dropdown.visible = false
        local disabled = page_frame.im_ia_priority_flow.add{type='button', name='im_ia_priority_disabled_button', caption={'gui-infinity-accumulator.priority-dropdown-tertiary'}}
        disabled.enabled = false
        disabled.style.horizontal_align = 'left'
        disabled.style.minimal_width = 116
    end

    local slider_flow = page_frame.add{type='flow', name='im_ia_slider_flow', direction='horizontal'}

    slider_flow.style.vertical_align = 'center'

    local value = entity.electric_buffer_size
    local len = string.len(string.format("%.0f", math.floor(value)))
    local exponent = math.max(len - (len % 3 == 0 and 3 or len % 3),3)
    value = math.floor(value / 10^exponent)

    elems.slider = slider_flow.add{type='slider', name='im_ia_slider', minimum_value=0, maximum_value=999, value=value}

    elems.slider.style.horizontally_stretchable = true

    elems.slider_textfield = slider_flow.add{type='textfield', name='im_ia_slider_textfield', text=value, numeric=true, lose_focus_on_confirm=true}
    elems.slider_textfield.style.width = 48
    elems.slider_textfield.style.horizontal_align = 'center'
    elems.prev_textfield_value = value

    local items = {}
    for i,v in pairs(power_prefixes) do
        items[i] = {'', {'si-prefix-symbol-' .. v}, {'si-unit-symbol-' .. power_suffixes_by_mode[mode]}}
    end

    elems.slider_dropdown = slider_flow.add{type='drop-down', name='im_ia_slider_dropdown', items=items, selected_index=(exponent/3)}

    elems.slider_dropdown.style.width = 65

    elems.entity = entity

    return elems
end

return page