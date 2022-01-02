(ns advent.y2021.day2)

(defn data []
  (->> (clojure.string/split (slurp "./resources/data/day2.txt")  #"\n")
       (map #(clojure.string/split % #" "))))

(defn alpha [] 'unsolved)
(defn beta  [] 'unsolved)
