CDF      
      
len_string     !   len_line   Q   four      	time_step          num_dim       	num_nodes         num_elem      
num_el_blk        num_node_sets         num_side_sets         num_el_in_blk1        num_nod_per_el1       num_side_ss1      
num_df_ss1        num_side_ss2      
num_df_ss2        num_side_ss3      
num_df_ss3        num_nod_ns1       num_nod_ns2       num_nod_ns3       num_nod_var       num_elem_var      num_info   �         api_version       @��R   version       @��R   floating_point_word_size            	file_size               title         out_rz.e      (   
time_whole                        [0   	eb_status                         
   eb_prop1               name      ID          
   	ns_status                         
   ns_prop1               name      ID          
$   	ss_status         	                
0   ss_prop1      	         name      ID          
<   coordx                         
H   coordy                         
h   
coor_names                          D  
�   eb_names                        $  
�   ns_names                        d  
�   ss_names      	                  d  T   connect1      
            	elem_type         QUAD4           �   elem_num_map                      �   elem_ss1                      �   side_ss1                      �   dist_fact_ss1                          �   elem_ss2                      �   side_ss2                      �   dist_fact_ss2                          �   elem_ss3                         side_ss3                          dist_fact_ss3                          $   node_ns1                      D   node_ns2                      L   node_ns3                      T   vals_nod_var1                             [8   vals_nod_var2                             [X   vals_nod_var3                             [x   vals_nod_var4                             [�   vals_nod_var5                             [�   vals_nod_var6                             [�   name_nod_var                        �  \   name_elem_var                           �  $   vals_elem_var1eb1            
                [�   vals_elem_var2eb1            
                \    vals_elem_var3eb1            
                \   vals_elem_var4eb1            
                \   info_records                      M�  �                                          ?�      ?�                              ?�      ?�                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 stress_yy                        plastic_strain_xx                plastic_strain_yy                plastic_strain_zz                disp_x                           disp_y                             stress_yy                        plastic_strain_xx                plastic_strain_yy                plastic_strain_zz                ####################                                                             # Created by MOOSE #                                                             ####################                                                                                                                                              [Mesh]                                                                             dim                            = 2                                               file                           = LSH_rz.e                                        second_order                   = 0                                               uniform_refine                 = 0                                             []                                                                                                                                                                [Variables]                                                                        active                         = 'disp_x disp_y '                                                                                                                 [./disp_x]                                                                         family                       = LAGRANGE                                          initial_condition            = 0                                                 initial_from_file_timestep   = 2                                                 order                        = FIRST                                             scaling                      = 1                                               [../]                                                                                                                                                             [./disp_y]                                                                         family                       = LAGRANGE                                          initial_condition            = 0                                                 initial_from_file_timestep   = 2                                                 order                        = FIRST                                             scaling                      = 1                                               [../]                                                                          []                                                                                                                                                                [Preconditioning]                                                                []                                                                                                                                                                [AuxVariables]                                                                                                                                                      [./stress_yy]                                                                      family                       = MONOMIAL                                          initial_condition            = 0                                                 initial_from_file_timestep   = 2                                                 order                        = CONSTANT                                          scaling                      = 1                                               [../]                                                                                                                                                             [./plastic_strain_xx]                                                              family                       = MONOMIAL                                          initial_condition            = 0                                                 initial_from_file_timestep   = 2                                                 order                        = CONSTANT                                          scaling                      = 1                                               [../]                                                                                                                                                             [./plastic_strain_yy]                                                              family                       = MONOMIAL                                          initial_condition            = 0                                                 initial_from_file_timestep   = 2                                                 order                        = CONSTANT                                          scaling                      = 1                                               [../]                                                                                                                                                             [./plastic_strain_zz]                                                              family                       = MONOMIAL                                          initial_condition            = 0                                                 initial_from_file_timestep   = 2                                                 order                        = CONSTANT                                          scaling                      = 1                                               [../]                                                                          []                                                                                                                                                                [Functions]                                                                        active                         = 'top_pull '                                                                                                                      [./top_pull]                                                                       type                         = ParsedFunction                                    vals                         =                                                   value                        = t*(1.0/5.0)                                       vars                         =                                                 [../]                                                                          []                                                                                                                                                                [Kernels]                                                                                                                                                           [./solid_x]                                                                        type                         = StressDivergenceRZ                                component                    = 0                                                 start_time                   = -1.79769e+308                                     stop_time                    = 1.79769e+308                                      variable                     = disp_x                                          [../]                                                                                                                                                             [./solid_y]                                                                        type                         = StressDivergenceRZ                                component                    = 1                                                 start_time                   = -1.79769e+308                                     stop_time                    = 1.79769e+308                                      variable                     = disp_y                                          [../]                                                                          []                                                                                                                                                                [AuxKernels]                                                                                                                                                        [./stress_yy]                                                                      type                         = StressAux                                         index                        = 1                                                 start_time                   = -1.79769e+308                                     stop_time                    = 1.79769e+308                                      variable                     = stress_yy                                       [../]                                                                                                                                                             [./plastic_strain_xx]                                                              type                         = PlasticStrainAux                                  index                        = 0                                                 start_time                   = -1.79769e+308                                     stop_time                    = 1.79769e+308                                      variable                     = plastic_strain_xx                               [../]                                                                                                                                                             [./plastic_strain_yy]                                                              type                         = PlasticStrainAux                                  index                        = 1                                                 start_time                   = -1.79769e+308                                     stop_time                    = 1.79769e+308                                      variable                     = plastic_strain_yy                               [../]                                                                                                                                                             [./plastic_strain_zz]                                                              type                         = PlasticStrainAux                                  index                        = 2                                                 start_time                   = -1.79769e+308                                     stop_time                    = 1.79769e+308                                      variable                     = plastic_strain_zz                               [../]                                                                          []                                                                                                                                                                [BCs]                                                                                                                                                               [./y_pull_function]                                                                type                         = FunctionDirichletBC                               boundary                     = '5 '                                              function                     = top_pull                                          start_time                   = -1.79769e+308                                     stop_time                    = 1.79769e+308                                      variable                     = disp_y                                          [../]                                                                                                                                                             [./x_bot]                                                                          type                         = DirichletBC                                       boundary                     = '4 '                                              start_time                   = -1.79769e+308                                     stop_time                    = 1.79769e+308                                      value                        = 0                                                 variable                     = disp_x                                          [../]                                                                                                                                                             [./y_bot]                                                                          type                         = DirichletBC                                       boundary                     = '3 '                                              start_time                   = -1.79769e+308                                     stop_time                    = 1.79769e+308                                      value                        = 0                                                 variable                     = disp_y                                          [../]                                                                          []                                                                                                                                                                [AuxBCs]                                                                         []                                                                                                                                                                [Materials]                                                                                                                                                         [./LSHRZ]                                                                          type                         = LSHPlasticMaterialRZ                              block                        = '1 '                                              disp_r                       = 'disp_x '                                         disp_z                       = 'disp_y '                                         hardening_constant           = 1206                                              max_its                      = 10                                                poissons_ratio               = 0.3                                               print_debug_info             = 1                                                 start_time                   = -1.79769e+308                                     stop_time                    = 1.79769e+308                                      t_ref                        = 0                                                 thermal_conductivity         = 0                                                 thermal_expansion            = 0                                                 tolerance                    = 1e-05                                             yield_stress                 = 240                                               youngs_modulus               = 210000                                          [../]                                                                          []                                                                                                                                                                [Executioner]                                                                      auto_scaling                   = 0                                               l_abs_step_tol                 = -1                                              l_max_its                      = 100                                             l_tol                          = 1e-09                                           nl_abs_step_tol                = 1e-50                                           nl_abs_tol                     = 1e-10                                           nl_max_funcs                   = 10000                                           nl_max_its                     = 100                                             nl_rel_step_tol                = 1e-50                                           nl_rel_tol                     = 1e-12                                           no_fe_reinit                   = 0                                               perf_log                       = 1                                               petsc_options                  = '-snes_mf_operator -ksp_monitor -snes_ksp_... ew '                                                                               petsc_options_iname            = '-snes_type -snes_ls -ksp_gmres_restart '       petsc_options_value            = 'ls basic 101 '                                 scheme                         = backward-euler                                  type                           = Transient                                       adapt_end_time                 = 1e+30                                           adapt_start_time               = 0                                               dt                             = 0.001                                           dtmax                          = 1e+30                                           dtmin                          = 0                                               end_time                       = 0.0105                                          initial_mesh_rebalance         = 0                                               n_startup_steps                = 0                                               num_steps                      = 1.79769e+308                                    ss_check_tol                   = 1e-08                                           ss_tmin                        = 0                                               start_time                     = 0                                               sync_times                     = '-1 '                                           trans_ss_check                 = 0                                             []                                                                                                                                                                [Postprocessors]                                                                 []                                                                                                                                                                [Output]                                                                           exodus                         = 1                                               file_base                      = out_rz                                          gmv                            = 0                                               gnuplot_format                 = ps                                              interval                       = 1                                               output_displaced               = 0                                               output_initial                 = 1                                               postprocessor_csv              = 0                                               postprocessor_ensight          = 0                                               postprocessor_gnuplot          = 0                                               postprocessor_screen           = 1                                               print_linear_residuals         = 0                                               print_out_info                 = 0                                               tecplot                        = 0                                               tecplot_binary                 = 0                                               xda                            = 0                                             []                                                                                                                                                                                                                                                                                                                          ?PbM���@D�����@D�����@D�����@D�����                                                                                                �uMU��uMU�                        ?*6��>F?*6��>F        @D�����                        ?`bM���@T�����G@T�����G@T�����G@T�����G                                                                                                �uMU��uMU�                        ?:6��@�?:6��@�        @T�����G                        ?h�t�j~�@_�   �@_�   �@_�   �@_�   �                                                                                                �'��9���'��9��                        ?C�*0U4x?C�*0U4x        @_�   �                        ?pbM���@e    f@e    f@e    f@e    f                                                                                                �/uMU K�/uMU K                        ?J6��G�?J6��G�        @e    f                        ?tz�G�{@j@   �@j@   �@j@   �@j@   �                                                                                                �3�*0U1M�3�*0U1M                        ?PbM��?PbM��        @j@   �                        ?x�t�j~�@n1R~"@n1R~"@n1R~"@n1R~"����f�/4����f�/4����f�/4����f�/4?��f�/%?��f�/%?��f�/%?��f�/%����f�/4����f�/4����f�/4����f�/4�8VqI^}e�8VqI^}e                        ?S�*0U2a?S�*0U2a        @n1R~"����f�/4?��f�/%����f�/4?|�1&�y@n	��7�@n	��7�@n	��7�@n	��7ʿ ���ѻ�� ���ѻ�� ���ѻ�� ���ѻ�?0���ѻ�?0���ѻ�?0���ѻ�?0���ѻ� ���ѻ�� ���ѻ�� ���ѻ�� ���ѻ��>�U�l��>�U�l�                        ?V�����?V�����        @n	��7ʿ ���ѻ�?0���ѻ� ���ѻ�?�bM���@n����@n����@n����@n�����-��f�0¿-��f�0¿-��f�0¿-��f�0�?=��f�0�?=��f�0�?=��f�0�?=��f�0տ-��f�0¿-��f�0¿-��f�0¿-��f�0¿B�d%-,�B�d%-,                        ?Z6��C-?Z6��C-        @n�����-��f�0�?=��f�0տ-��f�0�?�n��O�;@n74��@n74��@n74��@n74���5i	y�R0�5i	y�R0�5i	y�R0�5i	y�R0?Ei	y�R0?Ei	y�R0?Ei	y�R0?Ei	y�R0�5i	y�R0�5i	y�R0�5i	y�R0�5i	y�R0�E�C�#�E�C�#                        ?]}�H˒?]}�H˒        @n74���5i	y�R0?Ei	y�R0�5i	y�R0?�z�G�{@n ��b<@n ��b<@n ��b<@n ��b<�;�-�]�Ϳ;�-�]�Ϳ;�-�]�Ϳ;�-�]��?K�-�]��?K�-�]��?K�-�]��?K�-�]�Ŀ;�-�]�Ϳ;�-�]�Ϳ;�-�]�Ϳ;�-�]�ͿI? #���I? #��                        ?`bM���?`bM���        @n ��b<�;�-�]��?K�-�]�Ŀ;�-�]��?��$�/@n$�%��@@n$�%��@@n$�%��@@n$�%��@�?/?㛪�?/?㛪�?/?㛪�?/?㛪�?O/?㛪�?O/?㛪�?O/?㛪�?O/?㛪�?/?㛪�?/?㛪�?/?㛪�?/?㛪�J�yx���J�yx��                        ?a4�J�?a4�J�        @n$�%��@�?/?㛪�?O/?㛪�?/?㛪�