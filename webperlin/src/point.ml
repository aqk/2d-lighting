open Contypes

type 'a point = { x : 'a ; y : 'a }
type ipoint = int point
type fpoint = float point

type 'a point3 = { x : 'a ; y : 'a ; z : 'a }
type ipoint3 = int point3
type fpoint3 = float point3

module IPointOrd = struct
  type t = ipoint
  let compare = Pervasives.compare
end

module FPointOrd = struct
  type t = fpoint
  let compare = Pervasives.compare
end

module IPoint3Ord = struct
  type t = ipoint3
  let compare = Pervasives.compare
end

module FPoint3Ord = struct
  type t = fpoint3
  let compare = Pervasives.compare
end

module IPointMap = Map.Make(IPointOrd)
module IPoint3Map = Map.Make(IPoint3Ord)
module IPointFind = FindMap(IPointOrd)
module IPointUpdate = UpdateMap(IPointOrd)
module IPointList = ListToMap(IPointOrd)
