# This is a mechanical constraint (contact formulation) version of 4ElemTensionRelease.i
[Mesh]
  file = 4ElemTensionRelease.e
  displacements = 'disp_x disp_y'
[]

[Functions]
  [./up]
    type = PiecewiseLinear
    x = '0 1      2 3'
    y = '0 0.0001 0 -.0001'
  [../]
[]

[Variables]
  [./disp_x]
    order = FIRST
    family = LAGRANGE
  [../]

  [./disp_y]
    order = FIRST
    family = LAGRANGE
  [../]
[] # Variables

[SolidMechanics]
  [./solid]
    disp_x = disp_x
    disp_y = disp_y
  [../]
[]

[Contact]
  [./dummy_name]
    master = 2
    slave = 3
    disp_x = disp_x
    disp_y = disp_y
    penalty = 1e6
    model = frictionless
    tangential_tolerance = 0.01
    system = constraint
  [../]
[]

[BCs]

  [./lateral]
    type = PresetBC
    variable = disp_x
    boundary = '1 4'
    value = 0
  [../]

  [./bottom_up]
    type = FunctionPresetBC
    variable = disp_y
    boundary = 1
    function = up
  [../]

  [./top]
    type = PresetBC
    variable = disp_y
    boundary = 4
    value = 0.0
  [../]

[] # BCs

[Materials]

  [./stiffStuff1]
    type = Elastic
    block = 1

    disp_x = disp_x
    disp_y = disp_y

    youngs_modulus = 1e6
    poissons_ratio = 0.3
  [../]

  [./stiffStuff2]
    type = Elastic
    block = 2

    disp_x = disp_x
    disp_y = disp_y

    youngs_modulus = 1e6
    poissons_ratio = 0.3
  [../]
[] # Materials

[Executioner]
  type = Transient

  # Preconditioned JFNK (default)
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre    boomeramg      101'

  line_search = 'none'
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-10
  l_tol = 1e-4

  l_max_its = 100
  nl_max_its = 10
  dt = 0.1
  dtmin = 0.1
  num_steps = 30

  [./Predictor]
    type = SimplePredictor
    scale = 1.0
  [../]
[] # Executioner

[Outputs]
  exodus = true
[] # Outputs
