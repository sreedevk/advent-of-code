(ns advent.y2021.day2
  (:require clojure.string))

(defn data []
  (->> (clojure.string/split (slurp "./resources/data/2021/day2.txt")  #"\n")
       (map #(clojure.string/split % #" "))))

(defn ingest-instruction [state [pos mag]]
  (case pos
    "up" (assoc state :depth (- (:depth state) (Integer. mag)))
    "down" (assoc state :depth (+ (:depth state) (Integer. mag)))
    "forward" (assoc state :horizontal (+ (:horizontal state) (Integer. mag)))))

(defn ingest-projectile-instruction [state [pos mag]]
  (case pos
    "down" (assoc state :aim (+ (:aim state) (Integer. mag)))
    "up" (assoc state :aim (- (:aim state) (Integer. mag)))
    "forward" (-> (assoc state :horizontal (+ (:horizontal state) (Integer. mag)))
                  (assoc :depth (+ (:depth state) (* (Integer. mag) (:aim state)))))))

(defn alpha []
  (->>
    (reduce ingest-instruction {:depth 0, :horizontal 0} (data))
    (vals)
    (reduce *)))

(defn beta [] 
  (reduce *
    (-> (reduce ingest-projectile-instruction {:depth 0, :horizontal 0, :aim 0} (data))
        (select-keys [:depth :horizontal])
        (vals))))
