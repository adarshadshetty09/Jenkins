You can check **executors** and **nodes (agents)** in Jenkins in a few easy ways 👇

---

# ✅ 1️⃣ From Jenkins UI (Fastest way)

## 🧩 Check Total Nodes

Go to:

```
Jenkins Dashboard → Manage Jenkins → Nodes
```

Here you will see:

* master (built-in node)
* all agents you added

👉 Count = number of nodes.

---

## ⚙️ Check Executors per Node

Click any node:

```
Nodes → your-agent → Configure
```

Look for:

```
# of executors
```

Example:

```
Remote root dir: /home/adev4769_gmail_com/jenkins
# of executors: 2
```

That means this node can run **2 parallel builds**.

---

## 🧮 Check Total Executors (Quick Overview)

Go to:

```
Dashboard → Build Executor Status
```

You’ll see boxes like:

```
master #1
agent1 #1 #2
agent2 #1
```

Count the slots = total executors.

---

# ✅ 2️⃣ From Script Console (Backend / DevOps way)

If you want backend visibility:

```
Manage Jenkins → Script Console
```

Run:

```groovy
println "Total Nodes: " + Jenkins.instance.nodes.size()

Jenkins.instance.nodes.each { node ->
    println("${node.displayName} → Executors: ${node.numExecutors}")
}
```

Output example:

```
Total Nodes: 2
jenkins-slave-1 → Executors: 2
jenkins-slave-2 → Executors: 1
```

🔥 Very useful for automation/debugging.

---

# ✅ 3️⃣ From CLI / API (Automation Friendly)

Check executors via API:

```bash
curl http://JENKINS_URL/computer/api/json
```

Look for:

```
numExecutors
displayName
```

Good for scripts or monitoring.

---

# 🧠 Quick Understanding


| Term     | Meaning                          |
| -------- | -------------------------------- |
| Node     | Machine (agent/server)           |
| Executor | Parallel build slot on that node |

Example:

```
2 nodes
each has 2 executors
→ total parallel builds = 4
```

---
