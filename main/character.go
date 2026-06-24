components {
  id: "script"
  component: "/main/character.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"gray_square\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/main/gray_square.atlas\"\n"
  "}\n"
  ""
}
