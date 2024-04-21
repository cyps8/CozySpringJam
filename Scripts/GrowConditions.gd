extends Resource

class_name GrowConditions

enum Condition{ WATER, SUNLIGHT, DARKNESS, MOONLIGHT }

@export var stage1Water: bool = false
@export var stage1Sunlight: bool = false
@export var stage1Darkness: bool = false
@export var stage1Moonlight: bool = false

@export var stage2Water: bool = false
@export var stage2Sunlight: bool = false
@export var stage2Darkness: bool = false
@export var stage2Moonlight: bool = false

@export var stage3Water: bool = false
@export var stage3Sunlight: bool = false
@export var stage3Darkness: bool = false
@export var stage3Moonlight: bool = false

func GetConditionAtStage(stage: int, condition: Condition) -> bool:
    match condition:
        Condition.WATER:
            match stage:
                0:
                    return stage1Water
                1:
                    return stage2Water
                2:
                    return stage3Water
        Condition.SUNLIGHT:
            match stage:
                0:
                    return stage1Sunlight
                1:
                    return stage2Sunlight
                2:
                    return stage3Sunlight
        Condition.DARKNESS:
            match stage:
                0:
                    return stage1Darkness
                1:
                    return stage2Darkness
                2:
                    return stage3Darkness
        Condition.MOONLIGHT:
            match stage:
                0:
                    return stage1Moonlight
                1:
                    return stage2Moonlight
                2:
                    return stage3Moonlight
    return false