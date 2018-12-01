extends Spatial

class SomeInnerClass:
	extends Spatial
	
	const TYPE = "SomeInnerClass"
	
	var type = "SomeInnerClass"
	var projectile = null
	var model = null
	
	func _init(e=null):
		projectile = null
		
	func test():
		print(projectile, " : ", model)