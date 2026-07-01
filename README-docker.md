[Michele Mallia (CNR), 01.07.2026]

Il progetto è stato containerizzato mantenendo il meccanismo di avvio originale basato su build.sh, Ant e Jetty. È stato aggiunto un Dockerfile basato su Java 8 JDK, necessario per lo stack legacy del progetto, che utilizza componenti Ant/Cocoon non pienamente supportati da una sola JRE.

Sono stati aggiunti anche i file di supporto alla containerizzazione:
- compose.yaml, per gestire build, avvio, variabili d’ambiente, porta e memoria;
- .dockerignore, per ridurre il contesto di build;
- .gitattributes, per mantenere corretti i line ending degli script shell in ambiente Linux.

La configurazione Java è stata aggiornata per funzionare con un limite di memoria container pari a 4 GB. I parametri impostati sono:

```
JAVA_XMS: 256m
JAVA_XMX: 2560m
JAVA_MAX_METASPACE: 384m
mem_limit: 4g
```

È stato inoltre reso configurabile il context path della webapp tramite variabile d’ambiente:
`WEBAPP_CONTEXT_PATH: /cretaninscriptions`
In assenza di questa variabile, il default resta `/`. Per il deploy attuale la webapp è pubblicata sotto `/cretaninscriptions`.

Sono stati corretti anche i riferimenti agli asset statici, che ora vengono generati correttamente sotto il context path configurato, quindi come:
`/cretaninscriptions/assets/...`

Infine, è stato rimosso il riferimento esterno al CDN polyfill.io ed è stato sostituito con un polyfill locale incluso nel progetto: `webapps/ROOT/assets/scripts/polyfills.js`.
Questo evita dipendenze da servizi esterni e migliora stabilità e sicurezza del caricamento degli asset.
