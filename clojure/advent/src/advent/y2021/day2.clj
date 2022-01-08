(ns advent.y2021.day2
  (:require clojure.string))

(defn ingest-instruction [state instruction]
  (case state
    "up" (assoc state :depth (- (:depth state) (int (last instruction))))
    "down" (assoc state :depth (+ (:depth state) (int (last instruction))))
    "forward" (assoc state :depth (+ (:horizontal state) (int (last instruction))))))

(defn data []
  (->> (clojure.string/split (slurp "./resources/data/day2.txt")  #"\n")
       (map #(clojure.string/split % #" "))))

(defn alpha [] (reduce ingest-instruction {:depth 0, :horizontal 0} (data)))
(defn beta  [] 'unsolved)
