(ns advent.core
  (:require criterium.core)
  (:gen-class))

(defn AdventHelp []
  (println "AdventOfCode - Clojure\n")
  (println "USAGE:" "lein run <year> <day>")
  (println "EXAMPLE:" "lein run 2021 1"))

(defn -main [year day & args]
  (try
    (def solns (symbol (str "advent.y" year \. "day" day)))
    (require solns)
    (let [solver (find-ns solns)]
      (if (.contains (vec args) "benchmark")
        (do
          (criterium.core/with-progress-reporting (criterium.core/quick-bench (apply (ns-resolve solver 'alpha) []) :verbose))
          (criterium.core/with-progress-reporting (criterium.core/quick-bench (apply (ns-resolve solver 'beta) []) :verbose)))
        (do (println "\nPART I  (Alpha):\n" (apply (ns-resolve solver 'alpha) []))
            (println "\nPART II (Beta):\n" (apply (ns-resolve solver 'beta) [])))))
    (catch Exception e 
      (do (println e)
          (AdventHelp)))))
