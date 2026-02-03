// backend/src/ai/behavior.graph.ts

/**
 * VNC PLATFORM — BEHAVIOR GRAPH
 * FINAL & HARD-LOCKED
 *
 * Purpose:
 * - Correlate entities (users, devices, IPs)
 * - Detect suspicious shared patterns
 *
 * IMPORTANT:
 * - No persistence defined by tree
 * - Graph is process-scoped & deterministic
 */

export type GraphNodeType =
  | 'USER'
  | 'DEVICE'
  | 'IP'
  | 'SESSION';

export interface GraphNode {
  id: string;
  type: GraphNodeType;
}

export interface GraphEdge {
  from: string;
  to: string;
  relation: string;
  createdAt: Date;
}

/**
 * In-memory graph storage
 */
const nodes = new Map<string, GraphNode>();
const edges: GraphEdge[] = [];

/**
 * Add or get a node
 */
export function upsertNode(
  id: string,
  type: GraphNodeType,
): GraphNode {
  if (!nodes.has(id)) {
    nodes.set(id, { id, type });
  }
  return nodes.get(id)!;
}

/**
 * Link two nodes with a relation
 */
export function linkNodes(
  from: GraphNode,
  to: GraphNode,
  relation: string,
) {
  edges.push({
    from: from.id,
    to: to.id,
    relation,
    createdAt: new Date(),
  });
}

/**
 * Get all relations for a node
 */
export function getRelations(
  nodeId: string,
): GraphEdge[] {
  return edges.filter(
    (e) => e.from === nodeId || e.to === nodeId,
  );
}

/**
 * Detect shared connections between two users
 */
export function findSharedConnections(
  userA: string,
  userB: string,
): GraphEdge[] {
  const aEdges = getRelations(userA);
  const bEdges = getRelations(userB);

  return aEdges.filter((a) =>
    bEdges.some(
      (b) =>
        a.from === b.from ||
        a.to === b.to,
    ),
  );
}
