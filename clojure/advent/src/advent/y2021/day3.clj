(ns advent.y2021.day3
  (:require clojure.string)
  (:require clojure.set))

(defn data []
  (-> (slurp "./resources/data/2021/day3.txt")
      (clojure.string/split #"\n")))

(defn gamma-rate []
  (-> (->> (data)
           (map seq)                            ;; generates 2d matrix
           (apply map vector)                   ;; transposes the matrix
           (vec)                                ;; converts the seq to vec
           (map frequencies)                    ;; generates frequencies of elements in the inner vector
           (map clojure.set/map-invert)         ;; inverts the freq map
           (map #(get % (apply max (keys %))))  ;; gets the mode
           (clojure.string/join))
      (Integer/parseInt 2)))

(defn epsilon-rate []
  (-> (->> (data)
           (map seq)                            ;; generates 2d matrix
           (apply map vector)                   ;; transposes the matrix
           (vec)                                ;; converts the seq to vec
           (map frequencies)                    ;; generates frequencies of elements in the inner vector
           (map clojure.set/map-invert)         ;; inverts the freq map
           (map #(get % (apply min (keys %))))  ;; gets the antimode
           (clojure.string/join))
      (Integer/parseInt 2)))

(defn alpha []
  (* (epsilon-rate) (gamma-rate)))

(defn beta [] 'unsolved)
