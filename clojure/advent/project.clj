(defproject advent "0.0.1"
  :description "AdventOfCode Solutions"
  :url "https://www.sree.dev"
  :license {:name "MIT"
            :url "mit"}
  :dependencies [[org.clojure/clojure "1.10.3"]
                 [nrepl/nrepl "0.7.0"]
                 [cider/cider-nrepl "0.25.2"]
                 [criterium "0.4.6"]]
  :main ^:skip-aot advent.core
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all
                       :jvm-opts ["-Dclojure.compiler.direct-linking=true"]}})
