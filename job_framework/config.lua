Config = {}
Config.BlipName = {
    --['job-apply'] = "<FONT FACE='Oswald'><b>Nhận việc",
    --['cloak-room'] = "<FONT FACE='Oswald'><b>Phòng thay đồ",
    ['dealer'] = "<FONT FACE='Oswald'><b>Thương nhân",
    --['lamviec'] = "<FONT FACE='Oswald'><b>Khu đào đá",
}
Config.Jobs = {
    ['miner'] = {
        ['job-label'] = "<FONT FACE='Oswald'><b>Thợ Mỏ",
        ['main-pos'] = {
            --['job-apply'] = {x = 2327.1906738281, y = 2537.587890625, z = 41.422878265381},
            --['cloak-room'] = {x = 2631.9416503906, y = 2935.3500976562, z = 40.421634674072},
            ['dealer'] = {x = 2675.3825683594, y = 2762.4663085938, z = 37.878040313721, h = 28.338441848755},
            --['lamviec'] = {x = 2955.41, y = 2791.55, z = 40.91},
        },
        ['items'] = {
            ['copper'] = 250,
            ['gold'] = 3500,
            ['iron'] = 2500,
            ['diamond'] = 50000
        },
        ['level'] = {
            [1] = 0,
            [2] = 1500,
            [3] = 3000,
            [4] = 4000,
            [5] = 5000
        },
        ['uniform'] = {
            ['male'] = {
                tshirt_2 = 1,
                ears_1 = 8,
                glasses_1 = 15,
                torso_2 = 0,
                ears_2 = 2,
                glasses_2 = 3,
                shoes_2 = 1,
                pants_1 = 75,
                shoes_1 = 51,
                bags_1 = 0,
                helmet_2 = 0,
                pants_2 = 7,
                torso_1 = 71,
                tshirt_1 = 59,
                arms = 2,
                bags_2 = 0,
                helmet_1 = 0
            },
            ['female'] = {
                tshirt_2 = 3,
                decals_2 = 0,
                glasses = 0,
                hair_1 = 2,
                torso_1 = 73,
                shoes = 1,
                hair_color_2 = 0,
                glasses_1 = 19,
                skin = 13,
                face = 6,
                pants_2 = 5,
                tshirt_1 = 75,
                pants_1 = 37,
                helmet_1 = 57,
                torso_2 = 0,
                arms = 14,
                sex = 1,
                glasses_2 = 0,
                decals_1 = 0,
                hair_2 = 0,
                helmet_2 = 0,
                hair_color_1 = 0
            }
        },
        ['blip'] = {sprite = 318, color = 5},
        ['step'] = {
            [1] = {
                coords = {x = 2944.9641113281, y = 2794.4562988281, z = 40.584594726562},
                blip = {sprite = 121, color = 1, label = "Đào Đá"},
                helpMessage = "Nhấn [E] để thu hoạch đá",
                progressBar = {
                    label = "Đang đào đá",
                    duration = 8000
                },
                work = {
                    type = "gather",
                    radius = 100.0,
                    obj = {
                        "prop_rock_4_a", "prop_rock_4_cl_1", "rock_4_cl_2_2", "prop_rock_4_c_2", "prop_rock_5_smash3", "prop_rock_5_smash2", "rock_4_cl_2_1", "prop_rock_5_e", "prop_rock_5_d", "prop_rock_4_big"
                    },
                    ["max-spawn"] = 50,
                    scenario = "WORLD_HUMAN_CONST_DRILL",
                    require = nil,
                    reward = {
                        {name = "stone", count = 1, probability = 100},
                        -- {name = "kimloaithanbi", count = 1, probability = 3},
                    },
                    levelBonus = {
                        [1] = {
                            -- {name = "stone", count = 1, probability = 10}
                        },
                        [2] = {
                            -- {name = "stone", count = 1, probability = 40},
                            -- {name = "stone", count = 1, probability = 30},
                            -- {name = "stone", count = 1, probability = 10},
                        },
                        [3] = {
                            -- {name = "stone", count = 1, probability = 100},
                            -- {name = "stone", count = 1, probability = 30},
                            -- {name = "stone", count = 1, probability = 10},
                        },
                        [4] = {
                            -- {name = "stone", count = 1, probability = 100},
                            -- {name = "stone", count = 1, probability = 30},
                            -- {name = "stone", count = 1, probability = 20},
                            -- {name = "stone", count = 1, probability = 10},
                        },
                        [5] = {
                            -- {name = "stone", count = 1, probability = 100},
                            -- {name = "stone", count = 1, probability = 100},
                            -- {name = "stone", count = 1, probability = 30},
                            -- {name = "stone", count = 1, probability = 10},
                        }
                    }
                }
            },
            [2] = {
                coords = {x = 1903.1311035156, y = 261.8581237793, z = 161.85749816895},
                blip = {sprite = 121, color = 1, label = "Rửa Đá"},
                helpMessage = "Nhấn [E] để rửa đá",
                progressBar = {
                    label = "Đang rửa đá",
                    duration = 1000
                },
                work = {
                    type = "freeze",
                    require = {
                        {name = "stone", count = 1}
                    },
                    reward = {
                        {name = "washed_stone", count = 1, probability = 100}
                    }
                }
            },
            [3] = {
                coords = {x = 1109.2874755859, y = -2007.7858886719, z = 31.035409927368},
                blip = {sprite = 121, color = 1, label = "Luyện Đá"},
                helpMessage = "Nhấn [E] để luyện đá",
                progressBar = {
                    label = "Đang luyện đá",
                    duration = 2000
                },
                work = {
                    type = "freeze",
                    require = {
                        {name = "washed_stone", count = 1}
                    },
                    reward = {
                        {name = "copper", count = 5, probability = 83},
                        {name = "gold", count = 1, probability = 25},
                        {name = "iron", count = 2, probability = 30},
                        {name = "diamond", count = 1, probability = 1},
                    }
                }
            }
        }
    },
    ['slaughterer'] = {
        ['job-label'] = "<FONT FACE='Oswald'><b>Giết Mổ",
        ['main-pos'] = {
            --['job-apply'] = {x = -68.452209472656, y = 6255.3618164062, z = 31.090166091919},
            --['cloak-room'] = {x = 1200.8056640625, y = -1276.1540527344, z = 35.224983215332},
            ['dealer'] = {x = -76.099822998047, y = 6255.84375, z = 31.090009689331, h = 312.98025512695},
        },
        ['items'] = {
            ['packaged_bird'] = 4000,
            ['feathers'] = 1
        },
        ['level'] = {
            [1] = 0,
            [2] = 1500,
            [3] = 3000,
            [4] = 4000,
            [5] = 5000
        },
        ['uniform'] = {
            ['male'] = {
                tshirt_2 = 1,
                ears_1 = 8,
                glasses_1 = 15,
                torso_2 = 0,
                ears_2 = 2,
                glasses_2 = 3,
                shoes_2 = 1,
                pants_1 = 75,
                shoes_1 = 51,
                bags_1 = 0,
                helmet_2 = 0,
                pants_2 = 7,
                torso_1 = 71,
                tshirt_1 = 59,
                arms = 2,
                bags_2 = 0,
                helmet_1 = 0
            },
            ['female'] = {
                tshirt_2 = 3,
                decals_2 = 0,
                glasses = 0,
                hair_1 = 2,
                torso_1 = 73,
                shoes = 1,
                hair_color_2 = 0,
                glasses_1 = 19,
                skin = 13,
                face = 6,
                pants_2 = 5,
                tshirt_1 = 75,
                pants_1 = 37,
                helmet_1 = 57,
                torso_2 = 0,
                arms = 14,
                sex = 1,
                glasses_2 = 0,
                decals_1 = 0,
                hair_2 = 0,
                helmet_2 = 0,
                hair_color_1 = 0
            }
        },
        ['blip'] = {sprite = 268, color = 5},
        ['step'] = {
            [1] = {
                coords = {x = 2308.1862792969, y = 4933.8969726562, z = 41.414943695068},
                blip = {sprite = 121, color = 1, label = "Bắt Chim"},
                helpMessage = "Nhấn [E] để bắt chim",
                progressBar = {
                    label = "Đang bắt chim",
                    duration = 5000
                },
                work = {
                    type = "gather",
                    radius = 30.0,
                    objType = "ped",
                    obj = {
                        "a_c_chickenhawk"
                    },
                    ["max-spawn"] = 15,
                    scenario = "CODE_HUMAN_MEDIC_TEND_TO_DEAD",
                    require = nil,
                    reward = {
                        {name = "alive_bird", count = 1, probability = 100},
                        -- {name = "feathers", count = 1, probability = 20},
                    },
                    levelBonus = {
                        [1] = {
                            -- {name = "alive_bird", count = 1, probability = 30}
                        },
                        [2] = {
                            -- {name = "alive_bird", count = 1, probability = 40},
                            -- {name = "alive_bird", count = 1, probability = 30},
                            -- {name = "alive_bird", count = 1, probability = 10},
                        },
                        [3] = {
                            -- {name = "alive_bird", count = 1, probability = 100},
                            -- {name = "alive_bird", count = 1, probability = 30},
                            -- {name = "alive_bird", count = 1, probability = 10},
                        },
                        [4] = {
                            -- {name = "alive_bird", count = 1, probability = 100},
                            -- {name = "alive_bird", count = 1, probability = 30},
                            -- {name = "alive_bird", count = 1, probability = 20},
                            -- {name = "alive_bird", count = 1, probability = 10},
                        },
                        [5] = {
                            -- {name = "alive_bird", count = 1, probability = 100},
                            -- {name = "alive_bird", count = 1, probability = 100},
                            -- {name = "alive_bird", count = 1, probability = 30},
                            -- {name = "alive_bird", count = 1, probability = 10},
                        }
                    }
                }
            },
            [2] = {
                coords = {x = -78.088806152344, y = 6229.37890625, z = 31.091815948486},
                blip = {sprite = 121, color = 1, label = "Chặt Chim"},
                helpMessage = "Nhấn [E] để chặt chim",
                progressBar = {
                    label = "Đang chặt",
                    duration = 5000
                },
                work = {
                    type = "freeze",
                    scenario = "PROP_HUMAN_BUM_BIN",
                    require = {
                        {name = "alive_bird", count = 1}
                    },
                    reward = {
                        {name = "slaughtered_bird", count = 1, probability = 100},
                    }
                }
            },
            [3] = {
                coords = {x = -103.8553237915, y = 6206.263671875, z = 31.025020599365},
                blip = {sprite = 121, color = 1, label = "Đóng Gói KFC"},
                helpMessage = "Nhấn [E] để đóng gói",
                progressBar = {
                    label = "Đang đóng gói",
                    duration = 10000
                },
                work = {
                    type = "freeze",
                    scenario = "PROP_HUMAN_BBQ",
                    require = {
                        {name = "slaughtered_bird", count = 1}
                    },
                    reward = {
                        {name = "packaged_bird", count = 1, probability = 100}
                    }
                }
            }
        }
    },
}