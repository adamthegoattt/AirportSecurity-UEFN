import unreal

camera = unreal.Vector(-1750.0, -1240.0, 205.0)
target = unreal.Vector(510.0, -1300.0, 235.0)
rotation = unreal.MathLibrary.find_look_at_rotation(camera, target)
unreal.EditorLevelLibrary.set_level_viewport_camera_info(camera, rotation)
print({"queued": bool(unreal.AutomationLibrary.take_high_res_screenshot(1920, 1080, "AirportSecurity_centered_detector_player.png"))})
