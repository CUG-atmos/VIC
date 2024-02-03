using Clang
using Clang.Generators
using Ipaper

headers = [
  # "vic/dependency/shared_all/include/vic_driver_shared_all.h", 
  # "vic/dependency/vic_run/include/vic_def.h", 
  # "vic/dependency/vic_run/include/vic_physical_constants.h", 
  # "vic/dependency/vic_run/include/vic_run.h", 
  "vic/include/vic_driver_classic.h"
]

include_shaped_all = "-Ivic/dependency/shared_all/include"
include_vic_run = "-Ivic/dependency/vic_run/include"

args = get_default_args()
push!(args, include_vic_run, include_shaped_all)

options = load_options(joinpath(@__DIR__, "generator.toml"))


for f in headers
  _header = [f]
  fout = @pipe basename(f) |> gsub(_, ".h", ".jl")
  options["general"]["output_file_path"] = fout

  ctx = create_context(_header, args, options)
  build!(ctx)
end
