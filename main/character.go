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
embedded_components {
  id: "barrel"
  type: "sprite"
  data: "default_animation: \"gray_square\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/main/gray_square.atlas\"\n"
  "}\n"
  ""
  position {
    x: 45.0
  }
  scale {
    x: 0.75
    y: 0.25
  }
}
embedded_components {
  id: "bullet_factory"
  type: "factory"
  data: "prototype: \"/main/bullet.go\"\n"
  ""
}
