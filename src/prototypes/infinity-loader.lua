-- ------------------------------------------------------------------------------------------
-- ITEMS

data:extend{
    {
        type = 'item',
        name = 'infinity-loader',
        localised_name = {'entity-name.infinity-loader'},
        icons = {apply_infinity_tint{icon='__InfinityMode__/graphics/item/infinity-loader.png', icon_size=32}},
        stack_size = 50,
        place_result = 'infinity-loader-dummy-combinator',
        subgroup = 'im-misc',
        order = 'aa'
    }
}

register_recipes{'infinity-loader'}

-- ------------------------------------------------------------------------------------------
-- ENTITIES

local empty_sheet = {
    filename = "__core__/graphics/empty.png",
    priority = "very-low",
    width = 1,
    height = 1,
    frame_count = 1,
}

local loader_base = table.deepcopy(data.raw['underground-belt']['underground-belt'])
loader_base.icons = {apply_infinity_tint{icon='__InfinityMode__/graphics/item/infinity-loader.png', icon_size=32}}

local base_loader_path = '__base__/graphics/entity/underground-belt/'

data:extend{
    -- infinity chest
    {
        type = 'infinity-container',
        name = 'infinity-loader-chest',
        erase_contents_when_mined = true,
        inventory_size = 10,
        flags = {'hide-alt-info'},
        picture = empty_sheet,
        icons = loader_base.icons,
        collision_box = {{-0.05,-0.05},{0.05,0.05}}
    },
    -- dummy combinator (for placement and blueprints)
    {
        type = 'constant-combinator',
        name = 'infinity-loader-dummy-combinator',
        localised_name = {'entity-name.infinity-loader'},
        order = 'a',
        collision_box = loader_base.collision_box,
        fast_replaceable_group = 'transport-belt',
        placeable_by = {item='infinity-loader', count=1},
        flags = {'player-creation'},
        item_slot_count = 2,
        icons = loader_base.icons,
        sprites = {
            sheets = {
                apply_infinity_tint{
                    filename = base_loader_path..'underground-belt-structure-back-patch.png',
                    width = 96,
                    height = 96,
                    hr_version = apply_infinity_tint{
                        filename = base_loader_path..'hr-underground-belt-structure-back-patch.png',
                        width = 192,
                        height = 192,
                        scale = 0.5
                    }
                },
                apply_infinity_tint{
                    filename = '__InfinityMode__/graphics/entity/infinity-loader.png',
                    width = 96,
                    height = 96,
                    hr_version = apply_infinity_tint{
                        filename = '__InfinityMode__/graphics/entity/hr-infinity-loader.png',
                        width = 192,
                        height = 192,
                        scale = 0.5
                    }
                },
                apply_infinity_tint{
                    filename = base_loader_path..'underground-belt-structure-front-patch.png',
                    width = 96,
                    height = 96,
                    hr_version = apply_infinity_tint{
                        filename = base_loader_path..'hr-underground-belt-structure-front-patch.png',
                        width = 192,
                        height = 192,
                        scale = 0.5
                    }
                }
            }   
        },
        activity_led_sprites = empty_sheet,
        activity_led_light_offsets = {{0,0}, {0,0}, {0,0}, {0,0}},
        circuit_wire_connection_points = {
            {wire={},shadow={}},
            {wire={},shadow={}},
            {wire={},shadow={}},
            {wire={},shadow={}}
        }
    }
}

-- logic combinator is what is used for the loader logic. it's invisible, but is selectable and minable
local logic_combinator = table.deepcopy(data.raw['constant-combinator']['infinity-loader-dummy-combinator'])
logic_combinator.name = 'infinity-loader-logic-combinator'
logic_combinator.icons = {}
logic_combinator.sprites = empty_sheet
logic_combinator.selection_box = loader_base.selection_box
logic_combinator.minable = {result='infinity-loader', mining_time=0.1}
logic_combinator.flags = {'player-creation','hidden'}
data:extend{logic_combinator}

-- inserter
local filter_inserter = data.raw['inserter']['stack-filter-inserter']
data:extend{
    {
        type = 'inserter',
        name = 'infinity-loader-inserter',
        icons = {apply_infinity_tint{icon='__InfinityMode__/graphics/item/infinity-loader.png', icon_size=32}},
        stack = true,
        collision_box = {{-0.1,-0.1}, {0.1,0.1}},
        -- selection_box = {{-0.1,-0.1}, {0.1,0.1}},
        -- selection_priority = 99,
        selectable_in_game = false,
        allow_custom_vectors = true,
        energy_source = {type='void'},
        extension_speed = 1,
        rotation_speed = 0.5,
        energy_per_movement = '0.00001J',
        energy_per_extension = '0.00001J',
        pickup_position = {0, -0.2},
        insert_position = {0, 0.2},
        filter_count = 1,
        draw_held_item = false,
        platform_picture = empty_sheet,
        hand_base_picture = empty_sheet,
        hand_open_picture = empty_sheet,
        hand_closed_picture = empty_sheet,
        -- hand_base_picture = filter_inserter.hand_base_picture,
        -- hand_open_picture = filter_inserter.hand_open_picture,
        -- hand_closed_picture = filter_inserter.hand_closed_picture,
        draw_inserter_arrow = false,
        flags = {'hide-alt-info'}
    }
}