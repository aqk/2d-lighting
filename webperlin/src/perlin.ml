open Contypes
open Constants

external generateNoise : int -> int -> float array = "generatePerlinNoise" [@@bs.module "perlin-noise"]

