extends Node2D

export(float) var xAdjust : float = 0

onready var img0 : Sprite = $S0
onready var img1 : Sprite = $S1
onready var img2 : Sprite = $S2
onready var img3 : Sprite = $S3
onready var img4 : Sprite = $S4
onready var img5 : Sprite = $S5

export(NodePath) var basedNodePath : NodePath

var basedNode : Node

onready var images : Array = [[img0, img1, img2], [img3, img4, img5]]

onready var imgSize : Vector2 = Vector2(img0.texture.get_width(), img0.texture.get_height())

export(int) var horizontalNum = 3
export(int) var verticalNum = 2

func _ready():
	basedNode = get_node(basedNodePath)

func _physics_process(_delta):
	ManageBG()
	ManageArray()

func InvertVertical() -> void:
	var second : Array = images[1];
	images[1] = images[0];
	images[0] = second;

func InvertHorizontal() -> void:
	var nums : Array = []
	for i in range(verticalNum):
		nums.append(images[i][0])
		images[i].pop_front()
		images[i].append(nums[i])
#	var second : Array = [images[0][1], images[1][1]];
#	images[0][1] = images[0][0];
#	images[1][1] = images[1][0];
#	images[0][0] = second[0];
#	images[1][0] = second[1];

func ManageBG() -> void:
	if (basedNode.global_position.x > images[0][0].global_position.x - imgSize.x/2):
		images[0][1].global_position.x = images[0][0].global_position.x + imgSize.x;
		images[1][1].global_position.x = images[1][0].global_position.x + imgSize.x;
	elif (basedNode.global_position.x < images[0][0].global_position.x + imgSize.x/2):
		images[0][1].global_position.x = images[0][0].global_position.x - imgSize.x;
		images[1][1].global_position.x = images[1][0].global_position.x - imgSize.x;

#	if (basedNode.global_position.y > images[0][0].global_position.y):
#		images[1][0].global_position.y = images[0][0].global_position.y + imgSize.y;
#		images[1][1].global_position.y = images[0][1].global_position.y + imgSize.y;
#	elif (basedNode.global_position.y < images[0][0].global_position.y):
#		images[1][0].global_position.y = images[0][0].global_position.y - imgSize.y;
#		images[1][1].global_position.y = images[0][1].global_position.y - imgSize.y;

func ManageArray():
	if (basedNode.global_position.x > images[0][0].global_position.x + imgSize.x/2):
		InvertHorizontal()
	elif (basedNode.global_position.x < images[0][0].global_position.x - imgSize.x/2):
		InvertHorizontal()
#
#	if (basedNode.global_position.y > images[0][0].global_position.y + imgSize.y/2):
#		InvertVertical()
#	elif (basedNode.global_position.y < images[0][0].global_position.y - imgSize.y/2):
#		InvertVertical()
