--[[ 
    Love2D Packing Prototype

    © 2025 Case @ Playing In Traffic
    MIT License - see LICENSE for terms.

    Support honest development.  
    Don't steal credit like a clown. :D
]]

--- @module data.levels
--- @description Handles data defs for all game levels.

return {

    --- @section Level 1
    --- Each level is indexed numerically [1], allowing fast lookups - not that it matters here...
    --- To add another level, just copy a block, change the index, and update the container/items.
    --- To load the level you're editing, go to `core/state.lua` and set `start_level = 1` to your desired index.

    --- ## Main Container
    --- This is the primary container — your main packing grid.
    --- - `cols` – Number of columns in the grid.
    --- - `rows` – Number of rows.

    --- ## Items
    --- These are your items or nested containers.
    --- Any item can be a container by adding `container = true`, letting it hold other items.
    --- - `name` – Currently unused, was going to draw some icons but... eh, colored cubes.
    --- - `colour` – RGB used for drawing the item. Open containers use a highlight tint.
    --- - `container` – Marks an item as a container (can hold others).
    --- - `shape` – 2D array (grid) defining the items footprint. `1` = filled cell.
    [1] = {
        main_container = { cols = 6, rows = 3 },
        items = {
            { 
                name = "LaptopBag", 
                colour = {0.2, 0.8, 0.2}, 
                container = true, 
                shape = {
                    {1,1,1},
                    {1,1,1},
                }
            },
            { 
                name = "Shirt", 
                colour = {0.8, 0.2, 0.2}, 
                shape = {
                    {1,1,1},
                    {1,1,1},
                }
            },
            { 
                name = "Shoes", 
                colour = {0.2, 0.2, 0.8}, 
                shape = {
                    {1,1},
                    {1,1},
                }
            },
            { 
                name = "Laptop", 
                colour = {0.8, 0.8, 0.2}, 
                shape = {
                    {1,1,1,1},
                }
            },
            { 
                name = "Keys", 
                colour = {0.3, 0.4, 0.2}, 
                shape = {
                    {1},
                    {1}
                }
            },
            { 
                name = "Card", 
                colour = {0.6, 0.35, 0.2}, 
                shape = {
                    {1, 1},
                }
            },
        }
    },

    [2] = {
        main_container = { cols = 4, rows = 5 },
        items = {
            {
                name = "Backpack",
                colour = {0.1, 0.6, 0.3},
                container = true,
                shape = {
                    {1,1,1},
                    {1,1,1},
                    {1,1,1},
                }
            },
            {
                name = "LunchBox",
                colour = {0.7, 0.4, 0.1},
                container = true,
                shape = {
                    {1,1},
                    {1,1},
                }
            },
            {
                name = "WaterBottle",
                colour = {0.2, 0.4, 0.9},
                shape = {
                    {1},
                    {1},
                    {1},
                }
            },
            {
                name = "Notebook",
                colour = {0.8, 0.8, 0.2},
                shape = {
                    {1,1,1,1},
                }
            },
            {
                name = "Sandwich",
                colour = {0.9, 0.6, 0.3},
                shape = {
                    {1,1},
                }
            },
            {
                name = "Apple",
                colour = {0.8, 0.1, 0.1},
                shape = {
                    {1,1},
                }
            },
            {
                name = "Headphones",
                colour = {0.5, 0.1, 0.7},
                shape = {
                    {1,1,1},
                }
            },
            {
                name = "Headphones 2",
                colour = {0.1, 0.8, 0.7},
                shape = {
                    {1},
                }
            },
            {
                name = "Headphones 2",
                colour = {0.4, 0.1, 0.3},
                shape = {
                    {1},
                    {1},
                    {1, 1},
                }
            },
            {
                name = "Sandwich 2",
                colour = {0.6, 0.8, 0.5},
                shape = {
                    {1},
                }
            },
        }
    },

    [3] = {
        main_container = { cols = 7, rows = 4 },
        items = {
            {
                name = "DuffelBag",
                colour = {0.2, 0.5, 0.7},
                container = true,
                shape = {
                    {1,1,1,1},
                    {1,1,1,1},
                }
            },
            {
                name = "MakeupBag",
                colour = {0.9, 0.3, 0.6},
                container = true,
                shape = {
                    {1,1},
                    {1,1},
                }
            },
            {
                name = "PencilCase",
                colour = {0.3, 0.3, 0.9},
                container = true,
                shape = {
                    {1,1,1},
                }
            },
            {
                name = "Towel",
                colour = {0.9, 0.9, 0.4},
                shape = {
                    {1,1,1,1,1},
                    {1,1,1,1,1},
                }
            },
            {
                name = "MakeupBag 2",
                colour = {0.2, 0.9, 0.1},
                container = true,
                shape = {
                    {1,1},
                    {1,1},
                }
            },
            {
                name = "Shoes",
                colour = {0.2, 0.2, 0.8},
                shape = {
                    {1,1},
                    {1,1},
                }
            },
            {
                name = "Toothbrush",
                colour = {0.1, 0.8, 0.4},
                shape = {
                    {1},
                }
            },
            {
                name = "Charger",
                colour = {0.6, 0.6, 0.6},
                shape = {
                    {1,1},
                }
            },
            {
                name = "Socks",
                colour = {0.8, 0.1, 0.1},
                shape = {
                    {1},
                    {1}
                }
            },
            {
                name = "Socks 2",
                colour = {0.6, 0.3, 0.3},
                shape = {
                    {1},
                    {1}
                }
            },
            {
                name = "Socks 3",
                colour = {0.1, 0.2, 0.6},
                shape = {
                    {1, 1, 1}
                }
            },
            {
                name = "Socks 3",
                colour = {0.4, 0.4, 0.1},
                shape = {
                    {1, 1}
                }
            },
            {
                name = "Socks 3",
                colour = {0.3, 0.5, 0.1},
                shape = {
                    {1, 1}
                }
            },
        }
    },

    [4] = {
        main_container = { cols = 5, rows = 3 },
        items = {
            {
                name = "Bag",
                colour = {0.8, 0.2, 0.2}, 
                container = true,
                shape = {
                    {1,1,1,1},
                    {1,1,1,1},
                }
            },
            {
                name = "Bag2",
                colour = {0.2, 0.2, 0.8}, 
                container = true,
                shape = {
                    {1,0},
                    {1,1},
                }
            },
            {
                name = "Bag2",
                colour = {0.2, 0.8, 0.2}, 
                shape = {
                    {1,0},
                    {1,1},
                }
            },
            {
                name = "L",
                colour = {0.6, 0.4, 0.4},
                shape = {
                    {1,1},
                    {0,1},
                }
            },
            {
                name = "Item",
                colour = {0.3, 0.4, 0.2}, 
                shape = {
                    {1},
                    {1},
                    {1,1},
                }
            },
            {
                name = "Charger",
                colour = {0.6, 0.6, 0.6},
                container = true,
                shape = {
                    {1,1},
                }
            },
            {
                name = "Charger",
                colour = {0.5, 0.1, 0.7},
                container = true,
                shape = {
                    {1},
                }
            },
            {
                name = "Charger",
                colour = {0.3, 0.3, 0.3},
                shape = {
                    {1},
                }
            },
            {
                name = "Charger",
                colour = {0.6, 0.35, 0.2}, 
                shape = {
                    {1, 1},
                }
            },
            {
                name = "Charger",
                colour = {0.6, 0.85, 0.8}, 
                shape = {
                    {1},
                }
            }
        }
    },

    [5] = {
        main_container = { cols = 4, rows = 3 },
        items = {
            {
                name = "Bag",
                colour = {0.8, 0.2, 0.2}, 
                container = true,
                shape = {
                    {1,1,1},
                    {1,1,1},
                }
            },
            {
                name = "Bag",
                colour = {0.2, 0.2, 0.1}, 
                container = true,
                shape = {
                    {1,1,1},
                    {1,1,1},
                }
            },
            {
                name = "Bag2",
                colour = {0.2, 0.2, 0.8}, 
                container = true,
                shape = {
                    {1,0},
                    {1,1},
                }
            },
            {
                name = "Bag2",
                colour = {0.5, 0.3, 0.8}, 
                container = true,
                shape = {
                    {1,1},
                    {0,1},
                }
            },
            {
                name = "Charger",
                colour = {0.6, 0.85, 0.8},
                container = true,
                shape = {
                    {1},
                }
            },
             {
                name = "Bag2",
                colour = {0.7, 0.7, 0.7}, 
                shape = {
                    {1,1},
                    {0,1},
                }
            },
            {
                name = "Bag2",
                colour = {0.2, 0.8, 0.2}, 
                shape = {
                    {1,0},
                    {1,1},
                }
            },
            {
                name = "Bag2",
                colour = {0.9, 0.9, 0.9}, 
                shape = {
                    {1,0},
                    {1,1},
                }
            },
            {
                name = "Charger",
                colour = {0.3, 0.3, 0.3},
                shape = {
                    {1, 1},
                }
            },
            {
                name = "Charger",
                colour = {0.1, 0.5, 0.3},
                shape = {
                    {1},
                }
            },
        }
    }
}
