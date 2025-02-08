local _ = wesnoth.textdomain "wesnoth-h2tt"

-- https://wiki.wesnoth.org/LuaAPI/types/widget

-- metatable for GUI tags
local T = wml.tag

-- helpful debug function for printing a table
function tprint (tbl, indent)
	if not indent then indent = 0 end
	local toprint = string.rep(" ", indent) .. "{\r\n"
	indent = indent + 2 
	for k, v in pairs(tbl) do
		toprint = toprint .. string.rep(" ", indent)
		if (type(k) == "number") then
			toprint = toprint .. "[" .. k .. "] = "
		elseif (type(k) == "string") then
			toprint = toprint  .. k ..  "= "   
		end
		if (type(v) == "number") then
			toprint = toprint .. v .. ",\r\n"
		elseif (type(v) == "string") then
			toprint = toprint .. "\"" .. v .. "\",\r\n"
		elseif (type(v) == "table") then
			toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
		else
			toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
		end
	end
	toprint = toprint .. string.rep(" ", indent-2) .. "}"
	return toprint
end





















--###########################################################################################################################################################
--                                                                 SCENARIO PREVIEW
--###########################################################################################################################################################
function display_scenario_preview(cfg)
	--###############################
	-- PREPARE ARGUMENTS
	--###############################
	local title = cfg.title
	local scenario = cfg.scenario -- e.g. "s01"
	local preview_image = cfg.preview or "bigmap/preview-"..scenario..".png"
	local difficulty = "bigmap/difficulty"..cfg.difficulty..".png" -- e.g. "difficulty1.png"
	local initial_gold = cfg.initial_gold or "???";
	
	-------------------------
	-- REWARD: RECRUITS
	-------------------------
	local recruitlabel = cfg.recruitlabel and cfg.recruitlabel or _"New Recruits:"
	local recruit1     = cfg.recruit1     and cfg.recruit1.."~RC(magenta>red)" or "misc/blank-hex.png"
	local recruit2     = cfg.recruit2     and cfg.recruit2.."~RC(magenta>red)" or "misc/blank-hex.png"
	local recruit3     = cfg.recruit3     and cfg.recruit3.."~RC(magenta>red)" or "misc/blank-hex.png"
	local recruit4     = cfg.recruit4     and cfg.recruit4.."~RC(magenta>red)" or "misc/blank-hex.png"
	
	-------------------------
	-- REWARD: COMPANION
	-------------------------
	local companion1 = cfg.companion1 and cfg.companion1.."~RC(magenta>red)~BLIT(misc/loyal-icon.png,5,10)" or "misc/blank-hex.png"
	local companion2 = cfg.companion2 and cfg.companion2.."~RC(magenta>red)~BLIT(misc/loyal-icon.png,5,10)" or "misc/blank-hex.png"
	
	-------------------------
	-- REWARD: OTHER
	-------------------------
	local otherlabel = cfg.otherlabel or ""
	local other1     = cfg.other1 and cfg.other1.."~RC(magenta>red)" or "misc/blank-hex.png"
	local other2     = cfg.other2 and cfg.other2.."~RC(magenta>red)" or "misc/blank-hex.png"
	
	-------------------------
	-- REWARD: GOLD
	-------------------------
	local gold = cfg.gold
	if (gold==0) then gold="<span color='#ad6a61'>NONE</span>" end
	if (gold==1) then gold="<span color='#a9a150'>LOW</span>" end
	if (gold==2) then gold="<span color='#6ca364'>HIGH</span>" end
	
	--###############################
	-- DEFINE GRID
	--###############################
	local grid = T.grid{ T.row{
		T.column{ T.label{  use_markup=true,  label="<span size='40000'> </span>"  }}, 
		T.column{ border="right,left,bottom", border_size=18, T.grid{ 
			-------------------------
			-- TITLE
			-------------------------
			T.row{ T.column{ T.image{  label="icons/banner3.png"  }}},
			T.row{ T.column{ T.grid{ T.row{
				T.column{ T.image{
					-------------------------
					-- PREVIEW IMAGE
					-------------------------
					horizontal_alignment="left",
					label=preview_image,
				}},
				T.column{ T.label{ label="   " }}, 
				T.column{ T.grid{
					-------------------------
					-- TITLE AND DIFFICULTY
					-------------------------
					T.row{ T.column{ T.label{  use_markup=true,  label="<span size='5000'> </span>"  }}}, 
					T.row{ T.column{ 
						horizontal_alignment="left",
						T.label{  definition="title",label=title,  }
					}}, 
					T.row{ T.column{ T.label{  use_markup=true,  label="<span size='5000'> </span>"  }}}, 
					T.row{ T.column{
						horizontal_alignment="left",
						T.grid{ T.row{
							T.column{ T.label{  use_markup=true,  label=_"Difficulty: ",  }},
							T.column{ T.image{  label=difficulty,  }},
						}}
					}},
--					T.row{ T.column{
--						horizontal_alignment="left",
--						T.grid{ T.row{
--							T.column{ T.label{  use_markup=true,  label=_"Starting Gold: ",  }},
--							T.column{ T.label{  use_markup=true,  label=initial_gold,  }},
--						}}
--					}},
					T.row{ T.column{ T.label{  use_markup=true,  label="<span size='15000'> </span>"  }}}, 
					T.row{ T.column{ horizontal_alignment="left", T.image{  label="icons/banner2-half.png"  }}},
					T.row{ T.column{ T.label{  use_markup=true,  label="<span size='15000'> </span>"  }}}, 
					
					-------------------------
					-- REWARDS
					-------------------------
					T.row{ T.column{ 
						horizontal_alignment="left", -- hopefully "reward" makes it clear that this is what you're expected to have after the scenario, not before
						T.label{  use_markup=true,  label="Expected Gold Carryover Reward: <b>"..gold.."</b>",  },
					}},
					T.row{ T.column{ 
						vertical_alignment="top",
						horizontal_alignment="left",
						T.grid{ T.row{ 
							T.column{ T.label{  id="recruit0",  use_markup=true,  label=recruitlabel,  }},
							T.column{ T.image{  id="recruit1",  label=recruit1  }},
							T.column{ T.image{  id="recruit2",  label=recruit2  }},
							T.column{ T.image{  id="recruit3",  label=recruit3  }},
							T.column{ T.image{  id="recruit4",  label=recruit4  }},
						}},
					}},
					-- New Companion
					T.row{ T.column{ 
						vertical_alignment="top",
						horizontal_alignment="left", 
						T.grid{ T.row{ 
							T.column{ T.label{  id="companion0",  use_markup=true,  label="New Companions:",  }},
							T.column{ T.image{  id="companion1",  label=companion1  }},
							T.column{ T.image{  id="companion2",  label=companion2  }},
						}},
					}},
					-- Other
					T.row{ T.column{ 
						vertical_alignment="top",
						horizontal_alignment="left", 
						T.grid{ T.row{ 
							T.column{ T.label{  id="other0",  use_markup=true,  label=otherlabel,  }},
							T.column{ T.image{  id="other1",  label=other1  }},
							T.column{ T.image{  id="other2",  label=other2  }},
						}},
					}},
				}},
			}}}},
			T.row{ T.column{ T.label{  use_markup=true,  label="<span size='5000'> </span>"  }}}, 
			-------------------------
			-- BUTTONS
			-------------------------
			T.row{ T.column{ T.grid{ T.row{
				T.column{ T.grid{ T.row{
					T.column{ T.button{
						return_value=1, use_markup=true,
						label=_"Play",
					}},
					T.column{ T.label{ label="    " }},
					T.column{ T.button{
						return_value=2, use_markup=true,
						label=_"Cancel",
					}},
				}}},
			}}}},
		}},
		T.column{ T.label{  use_markup=true,  label="<span size='40000'> </span>"  }},
	}}
	
	
	--###############################
	-- CREATE DIALOG
	--###############################
	local result = wesnoth.sync.evaluate_single(function()
		local button = gui.show_dialog(
			{-- dialog definition
				definition="menu",
				T.helptip{ id="tooltip_large" }, -- mandatory field
				T.tooltip{ id="tooltip_large" }, -- mandatory field
				grid, 
			},
			-- preshow
			function(dialog)
				if (not cfg.recruit1) then
					dialog["recruit0"].visible = false
					dialog["recruit1"].visible = false
					dialog["recruit2"].visible = false
					dialog["recruit3"].visible = false
					dialog["recruit4"].visible = false
				end
				if (not cfg.companion1) then
					dialog["companion0"].visible = false
					dialog["companion1"].visible = false
					dialog["companion2"].visible = false
				end
			end
		)
		return { button=button }
	end)
	-- e.g `status_s01 = "in progress"`
	if (result.button==1) then wml.variables["status_"..cfg.scenario]="in_progress" end
end



















--###########################################################################################################################################################
--                                                                 SCENARIO PREVIEW
--###########################################################################################################################################################
function display_overworld_tutorial()
	--###############################
	-- DEFINE GRID
	--###############################
	local grid = T.grid{ T.row{ 
		T.column{ border="right,left,bottom", border_size=18, T.grid{ 
			-------------------------
			-- INTRO
			-------------------------
			T.row{ T.column{ T.image{  label="icons/banner3-narrow.png"  }}},
			T.row{ T.column{ T.label{  use_markup=true,  label="<span size='5000'> </span>"  }}}, 
			T.row{ T.column{ 
				horizontal_alignment="center",
				T.label{  definition="title",  label=_"Welcome to the Great Continent",  }
			}},
			T.row{ T.column{ T.label{  use_markup=true,  label="<span size='15000'> </span>"  }}}, 
			T.row{ T.column{
				horizontal_alignment="left",
				border="right,left", border_size=18,
				T.label{
					use_markup=true,
					label=_"The wide world of Wesnoth is full of all kinds of\ninteresting people! Unfortunately for Konrad, \nmost of them want to kill him.",
				}
			}},
			T.row{ T.column{ T.label{  use_markup=true,  label="<span size='15000'> </span>"  }}}, 
			-------------------------
			-- IMAGE
			-------------------------
			T.row{ T.column{ T.grid{ T.row{
				T.column{
					T.image{  label="bigmap/overworld-tutorial.png"  }
				},
				T.column{ T.label{  use_markup=true,  label="<span size='40000'> </span>"  }},
				T.column{ 
					horizontal_alignment="left",
					T.label{
						use_markup=true,
						label=_"To leave the overworld and play\na battle scenario, <i><b>move Konrad\nto one of the marked hexes.</b></i>",
					}
				}
			}}}},
			T.row{ T.column{ T.label{  use_markup=true,  label="<span size='9000'> </span>"  }}}, 
			T.row{ T.column {T.image{  label="icons/banner2-narrow.png"  }}},
			T.row{ T.column{ T.label{  use_markup=true,  label="<span size='9000'> </span>"  }}}, 
			-------------------------
			-- BUTTONS
			-------------------------
			T.row{ T.column{ T.button{
				return_value=1, use_markup=true,
				label=_"Understood",
			}}},
		}},
	}}
	
	--###############################
	-- CREATE DIALOG
	--###############################
	local result = wesnoth.sync.evaluate_single(function()
		local button = gui.show_dialog({
			definition="menu",
			T.helptip{ id="tooltip_large" }, -- mandatory field
			T.tooltip{ id="tooltip_large" }, -- mandatory field
			grid
		})
		return { button=button }
	end)
end


















--###########################################################################################################################################################
--                                                                      "MAIN"
--###########################################################################################################################################################
-------------------------
-- DEFINE WML TAGS
-------------------------
function wesnoth.wml_actions.display_scenario_preview(cfg)
	display_scenario_preview(cfg)
end
function wesnoth.wml_actions.display_overworld_tutorial()
	display_overworld_tutorial()
end


