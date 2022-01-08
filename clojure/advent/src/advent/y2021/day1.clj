(ns advent.y2021.day1)

(defn data []
  (->> (clojure.string/split (slurp "./resources/data/2021/day1.txt")  #"\n")
       (map #(Integer/parseInt %))))

(defn alpha []
  (->> (data)
       (partition 2 1)
       (filter #(apply < %))
       (count)))

(defn beta []
  (->> (data)
       (partition 3 1)
       (map #(apply + %))
       (partition 2 1)
       (filter #(apply < %))
       (count)))
