components {
  id: "script"
  component: "/main/bullet.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  scale {
    x: 0.35
    y: 0.18
  }
  data: "default_animation: \"gray_square\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/main/gray_square.atlas\"\n"
  "}\n"
  ""
}
