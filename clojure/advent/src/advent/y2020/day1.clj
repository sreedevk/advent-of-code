(ns advent.y2020.day1
  (:require clojure.string))

(defn data []
  (->> (-> (slurp "./resources/data/2020/day1.txt")
       (clojure.string/split #"\n"))
       (map #(Integer/parseInt %))))

(defn alpha []
  (let [inputs (data)]
    (reduce * (take 2 (filter #(.contains inputs (- 2020 %)) inputs)))))

(defn beta [] 'unsolved)
