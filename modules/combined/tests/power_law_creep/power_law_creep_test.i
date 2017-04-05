# 1x1x1 unit cube with uniform pressure on top face

[Mesh]
  file = 1x1x1_cube.e
  displacements = 'x_disp y_disp z_disp'
[]

[Variables]
  [./x_disp]
    order = FIRST
    family = LAGRANGE
  [../]

  [./y_disp]
    order = FIRST
    family = LAGRANGE
  [../]

  [./z_disp]
    order = FIRST
    family = LAGRANGE
  [../]

  [./temp]
    order = FIRST
    family = LAGRANGE
    initial_condition = 1000.0
  [../]
[]

[AuxVariables]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./creep_strain_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./creep_strain_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./creep_strain_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./elastic_strain_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Functions]
  [./top_pull]
    type = PiecewiseLinear

    x = '0 1'
    y = '1 1'
  [../]
[]

[SolidMechanics]
  [./solid]
    disp_x = x_disp
    disp_y = y_disp
    disp_z = z_disp
  [../]
[]

[Kernels]
  [./solid_x_ie]
    type = SolidMechImplicitEuler
    variable = x_disp
  [../]

  [./solid_y_ie]
    type = SolidMechImplicitEuler
    variable = y_disp
  [../]

  [./solid_z_ie]
    type = SolidMechImplicitEuler
    variable = z_disp
  [../]

  [./heat]
    type = HeatConduction
    variable = temp
  [../]

  [./heat_ie]
    type = HeatConductionTimeDerivative
    variable = temp
  [../]
[]


[AuxKernels]

  [./stress_yy]
    type = MaterialTensorAux
    tensor = stress
    variable = stress_yy
    index = 1
  [../]

  [./creep_strain_xx]
    type = MaterialTensorAux
    tensor = creep_strain
    variable = creep_strain_xx
    index = 0
  [../]

  [./creep_strain_yy]
    type = MaterialTensorAux
    tensor = creep_strain
    variable = creep_strain_yy
    index = 1
  [../]

  [./creep_strain_zz]
    type = MaterialTensorAux
    tensor = creep_strain
    variable = creep_strain_zz
    index = 2
  [../]

  [./elastic_strain_yy]
    type = MaterialTensorAux
    tensor = elastic_strain
    variable = elastic_strain_yy
    index = 1
  [../]

[]


[BCs]

  [./u_top_pull]
    type = Pressure
    variable = y_disp
    component = 1
    boundary = 5
    factor = -10.0e6
    function = top_pull
  [../]

  [./u_bottom_fix]
    type = DirichletBC
    variable = y_disp
    boundary = 3
    value = 0.0
  [../]

  [./u_yz_fix]
    type = DirichletBC
    variable = x_disp
    boundary = 4
    value = 0.0
  [../]

  [./u_xy_fix]
    type = DirichletBC
    variable = z_disp
    boundary = 2
    value = 0.0
  [../]

  [./temp_top_fix]
    type = DirichletBC
    variable = temp
    boundary = 5
    value = 1000.0
  [../]

  [./temp_bottom_fix]
    type = DirichletBC
    variable = temp
    boundary = 3
    value = 1000.0
  [../]

[]

[Materials]

  [./creep]
    type = PowerLawCreep
    block = 1
    youngs_modulus = 2.e11
    poissons_ratio = .3
    coefficient = 1.0e-15
    n_exponent = 4
    activation_energy = 3.0e5
    relative_tolerance = 1e-25
    absolute_tolerance = 1e-5
    max_its = 100
    disp_x = x_disp
    disp_y = y_disp
    disp_z = z_disp
    temp = temp
    output_iteration_info = false
  [../]

  [./thermal]
    type = HeatConductionMaterial
    block = 1
    specific_heat = 1.0
    thermal_conductivity = 100.
  [../]

  [./density]
    type = Density
    block = 1
    density = 1.0
    disp_x = x_disp
    disp_y = y_disp
    disp_z = z_disp
  [../]

[]

[Executioner]
  type = Transient
#  petsc_options = '-snes_mf_operator -ksp_monitor -snes_ksp_ew'

  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'


  petsc_options = '-snes_ksp'
  petsc_options_iname = '-ksp_gmres_restart'
  petsc_options_value = '101'


  line_search = 'none'


  l_max_its = 100
  nl_max_its = 100
  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-6
  l_tol = 1e-5
  start_time = 0.0
  end_time = 1.0
  num_steps = 10
  dt = 1.e-1
[]

[Outputs]
  exodus = true
[]
