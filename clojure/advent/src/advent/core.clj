(ns advent.core
  (:gen-class))

(defn AdventHelp []
  (println "AdventOfCode - Clojure\n")
  (println "USAGE:" "lein run <year> <day>")
  (println "EXAMPLE:" "lein run 2021 1"))

(defn -main [& args]
  (try
    (def solns (symbol (str "advent.y" (first args) \. "day" (last args))))
    (require solns)
    (let [solver (find-ns solns)]
    (println "PART I  (Alpha):"(apply (ns-resolve solver 'alpha) []))
    (println "PART II (Beta):" (apply (ns-resolve solver 'beta) [])))
    (catch Exception e (AdventHelp)))
  )
