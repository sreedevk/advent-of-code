(ns advent.y2021.day1)

(defn alpha []
  (->> (clojure.string/split (slurp "./resources/data/day1.txt")  #"\n")
       (map #(Integer/parseInt %))
       (partition 2 1)
       (filter #(apply < %))
       (count)))

(defn beta []
  :unsolved)
